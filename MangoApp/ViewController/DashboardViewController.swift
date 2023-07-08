//
//  DashboardViewController.swift
//  MangoApp
//
//  Created by Ganesh Patil on 07/07/23.
//

import UIKit

class DashboardViewController: UIViewController {

    @IBOutlet weak var filesFolderTV: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressBar: UIProgressView!

    private let dashboardVM = DashboardViewModel()

    var documentInteractionController: UIDocumentInteractionController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpTableView()
        self.setUpNavigationItem()
        self.fetchParentDir()
        
    }
}

// MARK: - UI releated
extension DashboardViewController {
    private func setUpView() {
        containerView.layer.borderColor = AppColorTheme.shared.borderColor.cgColor
        containerView.layer.borderWidth = 3
    }
    
    private func setUpNavigationItem() {
        let item = UIBarButtonItem(title: "Log out", style: .done, target: self, action: #selector(logout))
        self.navigationItem.rightBarButtonItem = item
    }
    
    @objc private func logout() {
        print("Logout")
        self.showLoader()
        dashboardVM.logout() { [weak self] (model, err) in
            guard let strongSelf = self else { return }
            strongSelf.hideLoader()
            if let err {
                strongSelf.showErrorAlert(error: err)
                return
            }
            UserPreferences.shared.deleteUser()
            strongSelf.navigateToLoginVC()
        }
    }
    
    private func setUpTableView() {
        self.filesFolderTV.register(UINib(nibName: FileFolderTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FileFolderTableViewCell.identifier)
        self.filesFolderTV.register(UINib(nibName: FirstCellTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: FirstCellTableViewCell.identifier)
        self.filesFolderTV.delegate = self
        self.filesFolderTV.dataSource = self
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.filesFolderTV.reloadData()
        }
    }
    
    private func navigateToLoginVC() {
        DispatchQueue.main.async {
            let vc = LoginViewController()
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource, UIDocumentInteractionControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dashboardVM.getNoOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FirstCellTableViewCell.identifier, for: indexPath) as? FirstCellTableViewCell else
            {
                return UITableViewCell()
            }
            cell.setUpCell(title: dashboardVM.getFullDirPath())
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FileFolderTableViewCell.identifier, for: indexPath) as? FileFolderTableViewCell else
        {
            return UITableViewCell()
        }
        cell.setUpCell(model: dashboardVM.getCellForRowAt(index: indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 34.0 : 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            dashboardVM.perfromBackAction()
            self.reloadTableView()
            return
        }
        self.getDetails(index: indexPath.row)
    }
    
    private func getDetails(index: Int) {
        self.showLoader()
        let folder = self.dashboardVM.getCellForRowAt(index: index)
        if let tempFolder = folder as? ShowableFolder {
            self.dashboardVM.getChildFolderContent(index: index, folder: tempFolder) { [weak self] err in
                guard let strongSelf = self else { return }
                strongSelf.hideLoader()
                if let err {
                    strongSelf.showErrorAlert(error: err)
                    return
                }
                strongSelf.reloadTableView()
            }
        } else if let file = folder as? ShowableFile {
            self.dashboardVM.downloadFile(file: file) { [weak self] (url, err) in
                guard let strongSelf = self else { return }
                strongSelf.hideLoader()
                if let err {
                    strongSelf.showErrorAlert(error: err)
                    return
                }
                strongSelf.presentFile(at: url!)
                
            }
        } else {
            self.hideLoader()
        }
    }

    func presentFile(at url: URL) {
        DispatchQueue.main.async {
            self.documentInteractionController = UIDocumentInteractionController(url: url)
            self.documentInteractionController?.delegate = self
            self.documentInteractionController?.presentPreview(animated: true)
        }
    }
    
    // MARK: - UIDocumentInteractionControllerDelegate
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self.navigationController ?? self
    }
}

// MARK: - Logical
extension DashboardViewController {
    private func fetchParentDir() {
        self.showLoader()
        self.dashboardVM.getParentFolder { [weak self] err in
            guard let strongSelf = self else { return }
            strongSelf.hideLoader()
            if let err {
                strongSelf.showErrorAlert(error: err)
            }
            strongSelf.reloadTableView()
        }
    }
}
