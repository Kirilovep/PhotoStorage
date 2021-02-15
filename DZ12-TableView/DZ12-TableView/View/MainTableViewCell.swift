//
//  MainTableViewCell.swift
//  DZ12-TableView
//
//  Created by shizo on 18.01.2021.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            nameLabel.alpha = 0.5
            imageLabel.alpha = 0.5
        } else {
            nameLabel.alpha = 1
            imageLabel.alpha = 1
        }
    }

 
    func configure(result: CellData) {
        nameLabel.text = result.name
        imageLabel.image = UIImage(named: result.imageNamed)
        
    }
    
}
