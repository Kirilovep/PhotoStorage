//
//  ImageTableViewCell.swift
//  DZ12-TableView
//
//  Created by shizo on 25.01.2021.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var nameOfImageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            nameOfImageLabel.alpha = 0.5
            cellImageView.alpha = 0.5
        } else {
            nameOfImageLabel.alpha = 1
            cellImageView.alpha = 1
        }
    }
    
}
