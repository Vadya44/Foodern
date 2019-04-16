//
//  CategoryTableViewCell.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 16/04/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
