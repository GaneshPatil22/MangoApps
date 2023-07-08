//
//  LogoutModel.swift
//  MangoApp
//
//  Created by Ganesh Patil on 08/07/23.
//

import Foundation

struct LogoutModel: Codable {
    let msResponse: Logout

    enum CodingKeys: String, CodingKey {
        case msResponse = "ms_response"
    }
}

struct Logout: Codable {
    let transactionID: String?
    let success: Success

    enum CodingKeys: String, CodingKey {
        case transactionID = "transaction_id"
        case success
    }
}

struct Success: Codable {
    let message: String
}
