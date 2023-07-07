//
//  NetworkService.swift
//  MangoApp
//
//  Created by Ganesh Patil on 06/07/23.
//

import Foundation
class NetworkLayer {
    private init() { }
    static let shared = NetworkLayer()
    
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
            completion(.failure(.InvalidURL("Invalid base URL")))
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
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.APIError(error.localizedDescription)))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(.SomethingWentWrong("Something went wrong. Received \(response.statusCode)")))
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
}
