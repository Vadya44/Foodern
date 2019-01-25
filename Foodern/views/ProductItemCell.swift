//
//  ProductItemCell.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 28/11/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import UIKit

class ProductItemCell : UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    
    func configure(product : ProductItem) {
        nameLabel.text = product.name
        if product.getTempVolume() != 0 {
            let tempVolume = String(format:"%.2f", product.getTempVolume())
            capacityLabel.text = "\(tempVolume)"
        }
    }
    
}
