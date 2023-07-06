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
        let loader = UIActivityIndicatorView(style: .large)
        loader.backgroundColor = .white
        loader.tag = loaderTag
        loader.center = view.center
        loader.startAnimating()
        
        view.isUserInteractionEnabled = false
        view.addSubview(loader)
    }
    
    func hideLoader() {
        if let loader = view.viewWithTag(loaderTag) as? UIActivityIndicatorView {
            loader.stopAnimating()
            loader.removeFromSuperview()
            view.isUserInteractionEnabled = true
        }
    }
}
