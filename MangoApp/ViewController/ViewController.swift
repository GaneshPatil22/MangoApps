//
//  ViewController.swift
//  MangoApp
//
//  Created by Ganesh Patil on 06/07/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let body = ["ms_request":["user":["api_key":"1a873e8982fdd7835bd00c56d68e33db3f695403","username":"iosuser@toke.com","password":"dGVtcDEyMw=="]]]
        
        NetworkLayer.shared.makeRequest(api: .login, responseType: UserModel.self, body: body) { result in
            switch result {
            case .success(let success):
                print("success")
                print(success)
            case .failure(let failure):
                print("failure")
                print(failure)
            }
        }
    }
}



