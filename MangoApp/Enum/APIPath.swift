//
//  APIPath.swift
//  MangoApp
//
//  Created by Ganesh Patil on 06/07/23.
//

import Foundation

enum APIPath {
    case login
    case logout
    case getMainFolder
    case getFolderContent(String)
    case URL(String)

    private func getBaseURL() -> String {
        return "https://toke.mangopulse.com"
    }

    func getAPIPath() -> String {
        switch self {
        case .login:
            return "\(getBaseURL())/api/login.json"
        case .logout:
            return "\(getBaseURL())/api/logout.json"
        case .getMainFolder:
            return "\(getBaseURL())/api/folders.json"
        case .getFolderContent(let id):
            return "\(getBaseURL())/api/folders/\(id)/files.json"
        case .URL(let string):
            return string
        }
    }
    
    func getRequetType() ->String {
        switch self {
        case .login, .logout:
            return "POST"
        default:
            return "GET"
        }
    }

    func getCommonHeader() -> [String: String] {
        var header = ["Content-Type": "application/json"]
        if let id = UserPreferences.shared.getUserID() {
            header[Constants.Cookie] = "\(Constants.FelixSessionId)=\(id)"
        }
        return header
    }
}
