//
//  ParentFolderModel.swift
//  MangoApp
//
//  Created by Ganesh Patil on 07/07/23.
//

import Foundation

struct ParentFolderModel: Codable {
    let msResponse: ParentFolderMSResponse

    enum CodingKeys: String, CodingKey {
        case msResponse = "ms_response"
    }
}

// MARK: - MSResponse
struct ParentFolderMSResponse: Codable {
    let transactionID: String?
    let folders: [DetailFolder]?

    enum CodingKeys: String, CodingKey {
        case transactionID = "transaction_id"
        case folders
    }
}

// MARK: - Folder
struct DetailFolder: Codable {
    let userID: String?
    let name, relativePath, folderRel, id: String?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name, relativePath
        case folderRel = "folder_rel"
        case id
    }
}

// MARK: - Welcome
struct SubFolderModel: Codable {
    let msResponse: Subfolder

    enum CodingKeys: String, CodingKey {
        case msResponse = "ms_response"
    }
}

// MARK: - MSResponse
struct Subfolder: Codable {
    let isDomainSuspended: String
    let transactionID: String?
    let totalCount: Int?
    let showInUpload, name, roleName: String?
    let files: [File]

    enum CodingKeys: String, CodingKey {
        case isDomainSuspended = "is_domain_suspended"
        case transactionID = "transaction_id"
        case totalCount = "total_count"
        case showInUpload = "show_in_upload"
        case name
        case roleName = "role_name"
        case files
    }
}

// MARK: - File
struct File: Codable {
    let id: Int?
    let filename: String
    let parentID: Int?
    let relativePath: String?
    let size: Int?
    let userID: Int?
    let previewURL, mobileStreamingURL: String?
    let previewUrl2: String?
    let description: String?
    let mLink: String?
    let videoURL, videoURLMobile: String?
    let internalLink: String?
    let publicLink: String?
    let isFolder: Bool
    let shortUrl: String?

    enum CodingKeys: String, CodingKey {
        case id, filename
        case parentID = "parent_id"
        case relativePath, size
        case userID = "user_id"
        case previewURL = "preview_url"
        case mobileStreamingURL = "mobile_streaming_url"
        case previewUrl2 = "preview_url2"
        case description
        case mLink
        case videoURL = "video_url"
        case videoURLMobile = "video_url_mobile"
        case internalLink = "internal_link"
        case publicLink = "public_link"
        case isFolder = "is_folder"
        case shortUrl = "short_url"
    }
}
