//
//  APIPath.swift
//  MangoApp
//
//  Created by Ganesh Patil on 06/07/23.
//

import Foundation

enum APIPath {
    case login

    func getBaseURL() -> String {
        return "https://toke.mangopulse.com"
    }

    func getAPIPath() -> String {
        switch self {
        case .login:
            return "\(getBaseURL())/api/login.json"
        }
    }
    
    func getRequetType() ->String {
        switch self {
        case .login:
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
