//
//  UIViewController.swift
//  MangoApp
//
//  Created by Ganesh Patil on 07/07/23.
//

import UIKit

extension UIViewController {
    private var loaderTag: Int { return 919191}
    func showLoader() {
        DispatchQueue.main.async {
            let loader = UIActivityIndicatorView(style: .large)
            loader.backgroundColor = .white
            loader.tag = self.loaderTag
            loader.center = self.view.center
            loader.startAnimating()
            
            self.view.isUserInteractionEnabled = false
            self.view.addSubview(loader)
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            if let loader = self.view.viewWithTag(self.loaderTag) as? UIActivityIndicatorView {
                loader.stopAnimating()
                loader.removeFromSuperview()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    
    func showErrorAlert(error: NetworkError) {
        DispatchQueue.main.async {
            let title = "Error"
            var message = "Something went worng \(error.localizedDescription)"
            switch error {
            case .InvalidURL(let string):
                message = string
            case .APIError(let string):
                message = string
            case .NoDataReceived(let string):
                message = string
            case .DecoderError(let string):
                message = string
            case .SomethingWentWrong(let string):
                message = string
            case .NotFound(let string):
                message = string
            case .Unauthorized(let string):
                message = string
            case .ServerCrashed(let string):
                message = string
            }

            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
}
