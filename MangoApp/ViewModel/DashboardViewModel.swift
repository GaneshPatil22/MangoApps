//
//  DashboardViewModel.swift
//  MangoApp
//
//  Created by Ganesh Patil on 07/07/23.
//

import Foundation

class DashboardViewModel {
    
    private var parentFolderModel: ParentFolderModel?
    var parentDir: ShowableFolder?
    var currentSelectedDir: ShowableFolder?
    private var fullPath: String = ""
    private var collectionViewDataSource: [ShowableFile]?
    
    func getNoOfRows() -> Int {
        return currentSelectedDir?.getCount() ?? 0
    }
    
    func getCellForRowAt(index: Int) -> FileAndFolder? {
        return currentSelectedDir?.getFileOrFolderAt(index)
    }
    
    func createParentDir() {
        parentDir = ShowableFolder(name: "Home", parentFolder: nil, filesAndFolders: nil, id: "-1")
        var allFolders: [FileAndFolder] = []
        allFolders.append(ShowableFolder(name: "", parentFolder: nil, filesAndFolders: nil, id: "-1"))
        for folder in self.parentFolderModel?.msResponse.folders ?? [] {
            let showAbleFolder = ShowableFolder(name: folder.name ?? "No Name", parentFolder: parentDir, filesAndFolders: nil, id: folder.id ?? "-1")
            allFolders.append(showAbleFolder)
        }
        self.fullPath = "Home"
        parentDir?.setFilesAndFolders(filesAndFolders: allFolders)
        self.currentSelectedDir = parentDir
    }
    
    func fetchedSubDir(index: Int, subDir: SubFolderModel) {
        guard let folder = self.getCellForRowAt(index: index) as? ShowableFolder else { return }
        
        var allFolders: [FileAndFolder] = []
        allFolders.append(ShowableFolder(name: "", parentFolder: nil, filesAndFolders: nil, id: "-1"))
        for folderOrFile in subDir.msResponse.files {
            if folderOrFile.isFolder {
                let showAbleFolder = ShowableFolder(name: folderOrFile.filename , parentFolder: folder, filesAndFolders: nil, id: "\(folderOrFile.id ?? -1)")
                allFolders.append(showAbleFolder)
            } else {
                let showAbleFile = ShowableFile(parentFolder: folder, name: folderOrFile.filename, id: "\(folderOrFile.id ?? -1)", shortUrl: folderOrFile.shortUrl, size: folderOrFile.size)
                allFolders.append(showAbleFile)
            }
        }
        self.fullPath += "/\(folder.getName())"
        folder.setFilesAndFolders(filesAndFolders: allFolders)
        self.currentSelectedDir = folder
    }
    
    func getFullDirPath() -> String {
        return fullPath
    }
    
    func perfromBackAction() {
        if currentSelectedDir?.parentFolder == nil { return }
        currentSelectedDir = currentSelectedDir?.parentFolder
        var arr = fullPath.components(separatedBy: "/")
        arr.removeLast()
        fullPath = arr.joined(separator: "/")
    }
    
    private func getCollectionViewDataSource() -> [ShowableFile]? {
        var filesArray: [ShowableFile]?
        for fileAndFolder in (self.currentSelectedDir?.getAllFilesAndFolders() ?? []) {
            if let file = fileAndFolder as? ShowableFile {
                if filesArray == nil {
                    filesArray = [file]
                } else {
                    filesArray?.append(file)
                }
            }
        }
        self.collectionViewDataSource = filesArray
        return filesArray
    }
    
    func getCollectionViewNoOfRows() -> Int {
        return self.collectionViewDataSource?.count ?? getCollectionViewDataSource()?.count ?? 0
    }
    
    private func getCollectionViewItemAt(index: Int) -> ShowableFile? {
        return (self.collectionViewDataSource ?? getCollectionViewDataSource())?[index]
    }
    
    func getCollectionViewItemAtTitle(index: Int) -> String {
        return (self.collectionViewDataSource ?? getCollectionViewDataSource())?[index].getName() ?? "No NAME"
    }
    
}

//MARK: - API calling
extension DashboardViewModel {
    func getParentFolder(completion: @escaping(NetworkError?) -> Void) {
        NetworkLayer.shared.makeRequest(api: .getMainFolder, responseType: ParentFolderModel.self) { [weak self] result in
            guard let strongSelf = self else {
                completion(.SomethingWentWrong("Not FOund self"))
                return
            }
            switch result {
            case .success(let success):
                strongSelf.parentFolderModel = success
                strongSelf.createParentDir()
                completion(nil)
            case .failure(let failure):
                completion(failure)
            }
        }
    }
    
    func logout(completion: @escaping (LogoutModel?, NetworkError?) -> Void) {
        NetworkLayer.shared.makeRequest(api: .logout, responseType: LogoutModel.self) { result in
            switch result {
            case .success(let success):
                completion(success, nil)
            case .failure(let failure):
                completion(nil, failure)
            }
        }
    }
    
    func getChildFolderContent(index: Int, folder: ShowableFolder?, comletion: @escaping (NetworkError?) -> Void) {
        guard let id = folder?.getId(), id != "-1" else {
            comletion(.SomethingWentWrong("Invalid ID"))
            return
        }
        NetworkLayer.shared.makeRequest(api: .getFolderContent(id), responseType: SubFolderModel.self) { [weak self] result in
            guard let strongSelf = self else {
                comletion(.SomethingWentWrong("Not Found Self"))
                return
            }
            switch result {
            case .success(let success):
                strongSelf.fetchedSubDir(index: index, subDir: success)
                comletion(nil)
            case .failure(let failure):
                print(failure)
                comletion(failure)
            }
        }
    }
    
    func downloadFile(file: ShowableFile, comletion: @escaping (URL?, NetworkError?) -> Void) {
        guard let stringUrl = file.getShortURL() else {
            comletion(nil, .SomethingWentWrong("Downloadedable URL is not valid"))
            return
        }
        
        guard let extention = file.getName().components(separatedBy: ".").last else {
            comletion(nil, .SomethingWentWrong("Not able to fetch file extenstion"))
            return
        }
        
        
        NetworkLayer.shared.downloadFile(api: .URL(stringUrl), extenstion: extention) { (url, err) in
           comletion(url, err)
        }
    }
}

protocol FileAndFolder {
    var parentFolder: ShowableFolder? { get }
    func getName() -> String
    func getId() -> String
}

protocol Downloadable {
    func getShortURL() -> String?
    func getFileSize() -> String
}

class ShowableFile: FileAndFolder, Downloadable {
    let parentFolder: ShowableFolder?
    private let name: String
    private let id: String
    private let shortUrl: String?
    private let size: Int?
    
    init(parentFolder: ShowableFolder, name: String, id: String, shortUrl: String?, size: Int?) {
        self.parentFolder = parentFolder
        self.name = name
        self.id = id
        self.shortUrl = shortUrl
        self.size = size
    }

    func getName() -> String {
        return self.name
    }
    
    func getId() -> String {
        return self.id
    }
    
    func getShortURL() -> String? {
        return self.shortUrl
    }
    
    func getFileSize() -> String {
        guard let size else {
            return "0 B"
        }
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB]
        formatter.isAdaptive = true
        formatter.includesUnit = true
        formatter.countStyle = .decimal
        formatter.zeroPadsFractionDigits = true
        
        return formatter.string(fromByteCount: Int64(size))
    }
}

class ShowableFolder: FileAndFolder {
    private let name: String
    let parentFolder: ShowableFolder?
    private var filesAndFolders: [FileAndFolder]?
    private let id: String

    init(name: String, parentFolder: ShowableFolder?, filesAndFolders: [FileAndFolder]?, id: String) {
        self.name = name
        self.parentFolder = parentFolder
        self.filesAndFolders = filesAndFolders
        self.id = id
    }

    func getName() -> String {
        return self.name
    }
    
    func setFilesAndFolders(filesAndFolders: [FileAndFolder]) {
        self.filesAndFolders = filesAndFolders
    }
    
    func getCount() -> Int {
        return filesAndFolders?.count ?? 0
    }
    
    func getFileOrFolderAt(_ index: Int) -> FileAndFolder? {
        if let filesAndFolders, filesAndFolders.count > index {
            return filesAndFolders[index]
        }
        return nil
    }
    
    func getId() -> String {
        return self.id
    }
    
    func getAllFilesAndFolders() -> [FileAndFolder] {
        return filesAndFolders ?? []
    }
}
