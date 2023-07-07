//
//  UserPreference.swift
//  MangoApp
//
//  Created by Ganesh Patil on 06/07/23.
//

import Foundation

class UserPreferences: Preference {
    static let shared = UserPreferences()
    private init() {}
    
    private let userModelKey = "USER_MODEL_KEY"
    private let userDefault = UserDefaults.standard
    
    var user: UserModel? {
        get {
            guard let userData = userDefault.data(forKey: userModelKey) else { return nil }
            do {
                let model = try JSONDecoder().decode(UserModel.self, from: userData)
                return model
            } catch {
                print("ERROR while fetching user data from userdefault")
                return nil
            }
        }
        set {
            do {
                let data = try JSONEncoder().encode(newValue)
                userDefault.set(data, forKey: userModelKey)
            } catch {
                print("ERROR fail to save user data to userdefault")
            }
        }
    }
    
    func setUser(_ user: UserModel?) {
        self.user = user
    }
    
    func getUser() -> UserModel? {
        return user
    }
    
    func getUserID() -> String? {
        return self.user?.msResponse.user?.token
    }
    
    func deleteUser() {
        userDefault.removeObject(forKey: userModelKey)
    }
    
    func isUserLoggedIn() -> Bool {
        return self.user != nil
    }
}

protocol Preference {
    func setUser(_ user: UserModel?)
    func getUser() -> UserModel?
    func getUserID() -> String?
}
