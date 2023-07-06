//
//  UserPreference.swift
//  MangoApp
//
//  Created by Ganesh Patil on 06/07/23.
//

import Foundation

class UserPreferences {
    static let shared = UserPreferences()
    private init() {}
    
    private var user: UserModel?
    
    func setUser(user: UserModel) {
        self.user = user
    }
    
    func getUserID() -> String? {
        return self.user?.msResponse.user?.token
    }
}
