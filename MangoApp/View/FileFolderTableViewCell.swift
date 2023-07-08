//
//  FileFolderTableViewCell.swift
//  MangoApp
//
//  Created by Ganesh Patil on 08/07/23.
//

import UIKit

class FileFolderTableViewCell: UITableViewCell {
    
    static let identifier = "FileFolderTableViewCell"

    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var folderFileImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpCell(model: FileAndFolder?) {
        if let folder = model as? ShowableFolder {
            folderFileImageView.image = UIImage(systemName: "folder.fill")
            titleLabel.text = folder.getName()
            sizeLabel.isHidden = true
            titleLabel.font = .boldSystemFont(ofSize: 20)
        } else if let file = model as? ShowableFile {
            folderFileImageView.image = UIImage(systemName: "doc.fill")
            titleLabel.text = file.getName()
            titleLabel.font = .boldSystemFont(ofSize: 16)
            sizeLabel.isHidden = false
            sizeLabel.text = "Size: \(file.getFileSize())"
        }
    }
    
}
