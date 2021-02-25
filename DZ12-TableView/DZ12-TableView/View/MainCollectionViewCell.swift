//
//  MainCollectionViewCell.swift
//  DZ12-TableView
//
//  Created by shizo on 28.01.2021.
//

import UIKit


class MainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var nameOfImageLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    

    func configure(result: CellData) {
        nameOfImageLabel.text = result.name
        cellImageView.image = UIImage(named: result.imageNamed)
        
    }
    
    func setSelectedAppearence(isSelected: Bool) {
        if isSelected {
            cellImageView.alpha = 0.5
        } else {
            cellImageView.alpha = 1
           
        }
    }
    
}
