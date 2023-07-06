//
//  LoginViewModel.swift
//  MangoApp
//
//  Created by Ganesh Patil on 06/07/23.
//

import Foundation

class LoginViewModel {
    var loginUserModel: LoginUserModel?
    
    func setLoginUserModel(loginUserModel: LoginUserModel) {
        self.loginUserModel = loginUserModel
    }
    
    func validate() -> String? {
        guard let email = loginUserModel?.email, !email.isEmpty else {
            return Constants.EmailEmptyErrorMessage
        }
        guard let password = loginUserModel?.password, !password.isEmpty else {
            return Constants.PasswordEmptyErrorMessage
        }
        guard let dommain = loginUserModel?.domainURL, !dommain.isEmpty else {
            return Constants.DomainURL
        }
        return nil
    }
    
    func loginAPI(completion: @escaping () -> Void?) {
        NetworkLayer.shared.makeRequest(api: .login, responseType: UserModel.self, body: loginUserModel?.getLoginRequestBody()) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
            completion()
        }
    }
    
}

struct LoginUserModel {
    let email: String?
    let password: String?
    let domainURL: String?
    
    func getEncryptedPassword() -> String? {
        guard let data = password?.data(using: .utf8) else {
            return nil
        }
        return data.base64EncodedString()
    }
    
    func getLoginRequestBody() -> [String: Any] {
        return ["ms_request":
                    ["user":
                        ["api_key": "1a873e8982fdd7835bd00c56d68e33db3f695403",
                         "username": email ?? "",
                         "password": getEncryptedPassword() ?? ""]]]
    }
}
