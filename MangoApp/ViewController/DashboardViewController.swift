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
    
    private let dashboardVM = DashboardViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setUpTableView()
        self.fetchParentDir()
        
    }
}

// MARK: - UI releated
extension DashboardViewController {
    private func setUpView() {
        containerView.layer.borderColor = AppColorTheme.shared.borderColor.cgColor
        containerView.layer.borderWidth = 3
    }
    
    private func setUpTableView() {
        self.filesFolderTV.register(UITableViewCell.self, forCellReuseIdentifier: "CELL")
        self.filesFolderTV.delegate = self
        self.filesFolderTV.dataSource = self
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {
            self.filesFolderTV.reloadData()
        }
    }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dashboardVM.getNoOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        cell.textLabel?.text = dashboardVM.getCellForRowAt(index: indexPath.row).name
        return cell
    }
    
    
}

// MARK: - Logical
extension DashboardViewController {
    private func fetchParentDir() {
        self.dashboardVM.getParentFolder { [weak self] err in
            guard let strongSelf = self else { return }
            if let err {
                strongSelf.showAlert(title: "ERROR", message: err.localizedDescription)
            }
            strongSelf.reloadTableView()
        }
    }
}
