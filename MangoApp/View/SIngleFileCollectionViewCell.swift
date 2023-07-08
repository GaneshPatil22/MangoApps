//
//  SIngleFileCollectionViewCell.swift
//  MangoApp
//
//  Created by Ganesh Patil on 09/07/23.
//

import UIKit

class SIngleFileCollectionViewCell: UICollectionViewCell {

    static let identifier = "SIngleFileCollectionViewCell"
    
    @IBOutlet weak var mainContaintView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var dismissCV: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupView(title: String) {
        self.setUpBorder(view: mainContaintView)
        self.setUpBorder(view: containerView)
        self.titleLabel.text = title
        
        self.titleLabel.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissCollectionView))

        self.titleLabel.addGestureRecognizer(guestureRecognizer)
    }
    
    @objc private func dismissCollectionView() {
        dismissCV?()
    }
    
    private func setUpBorder(view: UIView) {
        view.layer.borderWidth = 3
        view.layer.borderColor = AppColorTheme.shared.borderColor.cgColor
    }

    @IBAction func nextButtonAction(_ sender: Any) {
    }
}
