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
    
    var file: ShowableFile?
    let addViewTag = 11223344
    
    var dismissCV: (() -> Void)?
    var showErrorTost: ((NetworkError) -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        if let view = mainContaintView.viewWithTag(addViewTag) as? UIView {
            view.removeFromSuperview()
        }
    }
    
    func setupView(file: ShowableFile?) {
        self.file = file
        self.setUpBorder(view: mainContaintView)
        self.setUpBorder(view: containerView)
        self.titleLabel.text = file?.getName() ?? "Non file name present"
        
        self.titleLabel.isUserInteractionEnabled = true
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissCollectionView))

        self.titleLabel.addGestureRecognizer(guestureRecognizer)
        self.setUpPriview()
        
    }
    
    private func setUpPriview() {
        guard let fileExtension = self.file?.getExtention(), let fileURL = self.file?.getDownloadedFilePathURL() else {
            return
        }
        if fileExtension == "pdf" {
            let webView = UIWebView(frame: mainContaintView.bounds)
            webView.tag = addViewTag
            let request = URLRequest(url: fileURL)
            webView.loadRequest(request)
            mainContaintView.addSubview(webView)
        } else if fileExtension == "png" || fileExtension == "jpg" || fileExtension == "jpeg" {
            let imageView = UIImageView(frame: mainContaintView.bounds)
            imageView.tag = addViewTag
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(contentsOfFile: fileURL.path)
            mainContaintView.addSubview(imageView)
        } else {
            showErrorTost?(.SomethingWentWrong("Unsupported file type: \(fileExtension)"))
        }
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
