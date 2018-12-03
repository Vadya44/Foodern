//
//  CategoriesTableViewCell.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 02/12/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import UIKit

class CategoriesTableViewCell: UITableViewCell {
    @IBOutlet weak var contnView: UIView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryCheckMarkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func pick() {
        self.categoryCheckMarkImage.isHidden = false
    }
    
    func unPick() {
        self.categoryCheckMarkImage.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
