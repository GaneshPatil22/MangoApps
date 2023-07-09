//
//  LoginViewController.swift
//  MangoApp
//
//  Created by Ganesh Patil on 06/07/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    let loginVM = LoginViewModel()

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = Constants.Login
        lbl.textColor = AppColorTheme.shared.titleColor
        lbl.backgroundColor = .clear
        lbl.textAlignment = .center
        lbl.font = .boldSystemFont(ofSize: 24)
        return lbl
    }()
    
    let userEmailTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
//        tf.text = "iosuser@toke.com"
        return tf
    }()
    
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
//        tf.text = "temp123"
        return tf
    }()
    
    
    let domainTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.text = BaseURL.baseURL
        return tf
    }()
    
    lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(Constants.LoginButton, for: .normal)
        btn.layer.borderWidth = 3
        btn.layer.borderColor = AppColorTheme.shared.borderColor.cgColor
        btn.layer.cornerRadius = 20.0
        btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        btn.setTitleColor(AppColorTheme.shared.loginBtnTitleCOlor, for: .normal)
        btn.addTarget(self, action: #selector(loginBtnAction), for: .touchUpInside)
        return btn
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = AppColorTheme.shared.borderColor.cgColor
        view.layer.borderWidth = 3
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UserPreferences.shared.deleteUser()
        self.view.backgroundColor = AppColorTheme.shared.backgroundColor
        self.showVCAccordingToStatus()
    }
}

// MARK: - UI Related code
extension LoginViewController {
    private func setUpView() {
        view.addSubview(titleLabel)
        view.addSubview(containerView)

        containerView.addSubview(userEmailTextField)
        self.costomizeTextField(tf: userEmailTextField, placeHolderText: Constants.UserEmail)
        containerView.addSubview(passwordTextField)
        self.costomizeTextField(tf: passwordTextField, placeHolderText: Constants.Password)
        containerView.addSubview(domainTextField)
        self.costomizeTextField(tf: domainTextField, placeHolderText: Constants.DomainURL)

        containerView.addSubview(loginBtn)

        setTitleLabelConstraints()
        setContainerViewConstraints()
        setUserEmailConstraints()
        setPasswordConstraints()
        setDomainURLConstraints()
        setLoginBtnConstraints()
    }
    
    private func setTitleLabelConstraints() {
        titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: self.containerView.topAnchor, constant: -50).isActive = true
    }

    private func setContainerViewConstraints() {
        containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
    }

    private func setUserEmailConstraints() {
        userEmailTextField.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20).isActive = true
        userEmailTextField.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -20).isActive = true
        userEmailTextField.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 35).isActive = true
        userEmailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setPasswordConstraints() {
        passwordTextField.leadingAnchor.constraint(equalTo: self.userEmailTextField.leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: self.userEmailTextField.trailingAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: self.userEmailTextField.bottomAnchor, constant: 30).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setDomainURLConstraints() {
        domainTextField.leadingAnchor.constraint(equalTo: self.passwordTextField.leadingAnchor).isActive = true
        domainTextField.trailingAnchor.constraint(equalTo: self.passwordTextField.trailingAnchor).isActive = true
        domainTextField.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 30).isActive = true
        domainTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setLoginBtnConstraints() {
        loginBtn.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        loginBtn.widthAnchor.constraint(equalToConstant: 135).isActive = true
        loginBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loginBtn.topAnchor.constraint(equalTo: domainTextField.bottomAnchor, constant: 30).isActive = true
        loginBtn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -60).isActive = true
    }
    
    private func costomizeTextField(tf: UITextField, placeHolderText: String) {
        tf.layer.borderColor = AppColorTheme.shared.borderColor.cgColor
        tf.layer.borderWidth = 3
        let attributes = [NSAttributedString.Key.foregroundColor: AppColorTheme.shared.placeholderTextColor,
                          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
        let attributedPlaceholder = NSAttributedString(string: placeHolderText, attributes: attributes)
        
        tf.setPadding(left: 15, right: 15)
        tf.textColor = AppColorTheme.shared.titleColor
        
        tf.attributedPlaceholder = attributedPlaceholder
    }
}


//MARK: - Logical
extension LoginViewController {
    
    private func showVCAccordingToStatus() {
        if UserPreferences.shared.isUserLoggedIn() {
            self.showDashboard()
        } else {
            self.setUpView()
        }
    }
    
    private func showDashboard() {
        DispatchQueue.main.async {
            let vc = DashboardViewController()
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    @objc private func loginBtnAction() {
        loginVM.setLoginUserModel(loginUserModel:
                                    LoginUserModel(
                                        email: userEmailTextField.text,
                                        password: passwordTextField.text,
                                        domainURL: domainTextField.text))
        if let message = loginVM.validate() {
            showAlert(title: "ERROR", message: message)
            return
        }
        if let domain = domainTextField.text {
            BaseURL.baseURL = domain
        }
        
        showLoader()
        loginVM.loginAPI { [weak self] (userModel, err) in
            guard let strongSelf = self else { return }
            strongSelf.hideLoader()
            if let err {
                strongSelf.showErrorAlert(error: err)
                return
            }
            UserPreferences.shared.setUser(userModel)
            strongSelf.showDashboard()
        }
    }
}
