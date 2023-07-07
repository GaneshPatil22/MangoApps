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
    let conversationID, userID: String?
    let name, relativePath, folderRel, id: String?
    let isVirtualFolder: Bool?
    let updatedAt, childCount: Int?
    let showPermissionOptions, showApplyParentOption, canSave, isPinned: Bool?
    let folderTypeFromDB: String?
    let showInUpload, showInMove, filter: String?

    enum CodingKeys: String, CodingKey {
        case conversationID = "conversation_id"
        case userID = "user_id"
        case name, relativePath
        case folderRel = "folder_rel"
        case id
        case isVirtualFolder = "is_virtual_folder"
        case updatedAt = "updated_at"
        case childCount = "child_count"
        case showPermissionOptions = "show_permission_options"
        case showApplyParentOption = "show_apply_parent_option"
        case canSave = "can_save"
        case isPinned = "is_pinned"
        case folderTypeFromDB = "folder_type_from_db"
        case showInUpload = "show_in_upload"
        case showInMove = "show_in_move"
        case filter
    }
}
