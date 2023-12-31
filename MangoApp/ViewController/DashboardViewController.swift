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
    @IBOutlet weak var singleFileCollectionView: UICollectionView!

    private let dashboardVM = DashboardViewModel()

    var documentInteractionController: UIDocumentInteractionController?
    var showInPreview: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpTableView()
        self.setUpNavigationItem()
        self.fetchParentDir()
        self.setUpCollectionView()
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
    
    private func setUpCollectionView() {
        self.singleFileCollectionView.delegate = self
        self.singleFileCollectionView.dataSource = self
        
        self.singleFileCollectionView.register(UINib(nibName: SIngleFileCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: SIngleFileCollectionViewCell.identifier)
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.filesFolderTV.reloadData()
        }
    }
    
    private func reloadCollectionView(with index: Int = 0) {
        DispatchQueue.main.async {
            self.singleFileCollectionView.reloadData()
            self.singleFileCollectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .bottom, animated: true)
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
            self.downloadFile(file: file)
        } else {
            self.hideLoader()
        }
    }

    private func showCollectionView(with index: Int = 0, onlyRelaodCell: Bool) {
        DispatchQueue.main.async {
            self.singleFileCollectionView.isHidden = false
            self.filesFolderTV.isHidden = true
            if onlyRelaodCell {
                self.singleFileCollectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                return
            }
            self.reloadCollectionView(with: index)
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

extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dashboardVM.getCollectionViewNoOfRows()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SIngleFileCollectionViewCell.identifier, for: indexPath) as? SIngleFileCollectionViewCell else {
            return UICollectionViewCell()
        }
        let file = self.dashboardVM.getCollectionViewItemAt(index: indexPath.row)
        cell.dismissCV = dismissCV
        cell.showErrorTost = self.showErrorAlert
        cell.setupView(file: file)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let iPath = self.singleFileCollectionView.indexPathsForVisibleItems.first {
            print(iPath)
            guard let file = self.dashboardVM.getCollectionViewItemAt(index: iPath.row) else { return }
            self.showLoader()
            self.downloadFile(file: file, onlyReloadCell: true)
        }
    }
    
    func downloadFile(file: ShowableFile, onlyReloadCell: Bool = false) {
        print("Starting dowload file: \(file.getName())")
        self.dashboardVM.downloadFile(file: file, showInPreview: self.showInPreview) { [weak self] (url, err) in
            guard let strongSelf = self else { return }
            strongSelf.hideLoader()
            if let err {
                strongSelf.showErrorAlert(error: err)
                return
            }
            file.setDownloadedFilePathURL(downloadedURL: url)
            if strongSelf.showInPreview {
                strongSelf.presentFile(at: url!)
            } else {
                let newIndex = strongSelf.dashboardVM.getCollectionViewDatasourceIndex(for: file)
                strongSelf.showCollectionView(with: newIndex, onlyRelaodCell: onlyReloadCell)
            }
        }
        
//        let newIndex = self.dashboardVM.getCollectionViewDatasourceIndex(for: file)
//        self.showCollectionView(with: newIndex, onlyRelaodCell: onlyReloadCell)
//        self.hideLoader()
    }

    private func dismissCV() {
        self.singleFileCollectionView.isHidden = true
        self.filesFolderTV.isHidden = false
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
