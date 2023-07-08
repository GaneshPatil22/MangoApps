//
//  FirstCellTableViewCell.swift
//  MangoApp
//
//  Created by Ganesh Patil on 08/07/23.
//

import UIKit

class FirstCellTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    static let identifier = "FirstCellTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpCell(title: String) {
        self.titleLabel.text = title
    }
    
}
