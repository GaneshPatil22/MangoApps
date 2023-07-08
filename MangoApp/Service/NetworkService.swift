//
//  NetworkService.swift
//  MangoApp
//
//  Created by Ganesh Patil on 06/07/23.
//

import Foundation
class NetworkLayer: NSObject {
    private override init() { }
    static let shared = NetworkLayer()

    private let fileCache = NSCache<NSString, FileData>()

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        return session
    }()
    
    var fileDownloadCompletion: ((URL?, NetworkError?) -> Void)?


    /// Get request APi call method
    /// - Parameters:
    ///   - api: Takes API
    ///   - responseType: Type of response
    ///   - parameters: query Pamaters
    ///   - headers: request header
    ///   - body: request body
    ///   - completion: after API call either error or success model
    func makeRequest<T: Codable>(api: APIPath,
                                 responseType: T.Type,
                                 parameters: [String: String]? = nil,
                                 headers: [String: String]? = nil,
                                 body: [String: Any]? = nil,
                                 completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: api.getAPIPath()) else {
            completion(.failure(.InvalidURL("Invalid URL")))
            return
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let parameters = parameters {
            let queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            urlComponents?.queryItems = queryItems
        }
        guard let finalURL = urlComponents?.url else {
            completion(.failure(.InvalidURL("Invalid Final URL")))
            return
        }
        var request = URLRequest(url: finalURL)
        request.httpMethod = api.getRequetType()
        var commonHeaders = api.getCommonHeader()
        commonHeaders = commonHeaders.merge(dict1: commonHeaders, dict2: headers ?? [:])
        commonHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if let body, let httpBody = body.convertToData() {
            request.httpBody = httpBody
        }

        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.APIError(error.localizedDescription)))
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                let status = response.statusCode
                var internalError: NetworkError = .SomethingWentWrong("Something went wrong. Received \(response.statusCode)")
                if status == 401 {
                    internalError = .Unauthorized("Unauthorized Request")
                } else if status == 404 {
                    internalError = .NotFound("URL not found on server end")
                } else if status == 500 {
                    internalError = .ServerCrashed("Server crashed")
                }
                completion(.failure(internalError))
                return
            }

            guard let data = data, !data.isEmpty else {
                completion(.failure(.NoDataReceived("No data received")))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.DecoderError("Error in decoding")))
            }
        }.resume()
    }

    
    func downloadFile(api: APIPath,
                      extenstion: String,
                      completion: @escaping (URL?, NetworkError?) -> Void) {
        guard let fileURL = URL(string: api.getAPIPath()) else {
            completion(nil, .InvalidURL("Invalid file download url"))
            return
        }
        if let cachedFile = fileCache.object(forKey: fileURL.absoluteString as NSString) {
            print("FOUND file in cache: \(cachedFile)")
            completion(cachedFile.url, nil)
            return
        }

        var request = URLRequest(url: fileURL)
        request.httpMethod = api.getRequetType()
        let commonHeaders = api.getCommonHeader()
        commonHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        let downloadTask = session.downloadTask(with: request)
        downloadTask.taskDescription = fileURL.absoluteString + "###" + extenstion
        self.fileDownloadCompletion = completion
        downloadTask.resume()
    }
}

extension NetworkLayer: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let percent = Int(progress * 100)
        print("Download progress: \(percent)%")
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        let fileManager = FileManager.default
        let tempDirectoryURL = fileManager.temporaryDirectory
        
        let desc = downloadTask.taskDescription
        let arr = desc?.components(separatedBy: "###")

        let destinationURL = tempDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension((arr?.count ?? 0) > 1 ? arr![1] : "")

        do {
            try fileManager.moveItem(at: location, to: destinationURL)
            if (arr?.count ?? 0) > 0, let url = arr?[0] {
                let fileData = FileData(url: destinationURL)
                self.fileCache.setObject(fileData, forKey: url as NSString)
            }
            fileDownloadCompletion?(destinationURL, nil)
            print("File downloaded successfully")
        } catch {
            print("Error moving file: \(error)")
            fileDownloadCompletion?(nil, .SomethingWentWrong(error.localizedDescription))
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("Download error: \(error)")
            fileDownloadCompletion?(nil, .SomethingWentWrong(error.localizedDescription))
        }
    }
}

class FileData {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
}
