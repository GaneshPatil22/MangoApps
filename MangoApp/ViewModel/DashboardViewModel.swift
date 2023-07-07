//
//  DashboardViewModel.swift
//  MangoApp
//
//  Created by Ganesh Patil on 07/07/23.
//

import Foundation

class DashboardViewModel {
    
    var parentFolderModel: ParentFolderModel?
    
    func getParentFolder(completion: @escaping(NetworkError?) -> Void) {
        NetworkLayer.shared.makeRequest(api: .getMainFolder, responseType: ParentFolderModel.self) { [weak self] result in
            guard let strongSelf = self else {
                completion(.SomethingWentWrong("Not FOund self"))
                return
            }
            switch result {
            case .success(let success):
                strongSelf.parentFolderModel = success
                completion(nil)
            case .failure(let failure):
                completion(failure)
            }
        }
    }
    
    func getNoOfRows() -> Int {
        return parentFolderModel?.msResponse.folders?.count ?? 0
    }
    
    func getCellForRowAt(index: Int) -> DetailFolder {
        return (parentFolderModel?.msResponse.folders ?? [])[index]
    }
    
    
}
