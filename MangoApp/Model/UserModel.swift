//
//  UserModel.swift
//  MangoApp
//
//  Created by Ganesh Patil on 06/07/23.
//

import Foundation

struct UserModel: Codable {
    let msResponse: MSResponse

    enum CodingKeys: String, CodingKey {
        case msResponse = "ms_response"
    }
}

// MARK: - MSResponse
struct MSResponse: Codable {
    let transactionID: String?
    let isDomainSuspended: String?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case transactionID = "transaction_id"
        case isDomainSuspended = "is_domain_suspended"
        case user
    }
}

// MARK: - User
struct User: Codable {
    let id: Int?
    let email, name, photo, imageURL: String?
    let isFirstLogin, canUploadPhoto, token, secret: String?
    let audioFolder, imageFolder, videoFolder: Folder?

    enum CodingKeys: String, CodingKey {
        case id, email, name, photo
        case imageURL = "image_url"
        case isFirstLogin = "is_first_login"
        case canUploadPhoto = "can_upload_photo"
        case token = "_token"
        case secret = "_secret"
        case audioFolder = "audio_folder"
        case imageFolder = "image_folder"
        case videoFolder = "video_folder"
    }
}

// MARK: - Folder
struct Folder: Codable {
    let folderID: String?

    enum CodingKeys: String, CodingKey {
        case folderID = "folder_id"
    }
}
