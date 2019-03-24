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
    @IBOutlet weak var containerView: UIView!
    
    func configure(product : ProductItem) {
        self.containerView.layer.cornerRadius = self.containerView.bounds.height / 3
        self.containerView.layer.masksToBounds = true
        
        self.productImage.layer.cornerRadius = self.productImage.bounds.height / 3
        self.productImage.layer.masksToBounds = true
        self.nameLabel.text = product.name
        if product.getTempVolume() != 0 {
            let tempVolume = String(format:"%.2f", product.getTempVolume())
            self.capacityLabel.text = "\(tempVolume)"
        }
        self.productImage.image = DataManager.getImage(imageName: product.name)
    }
    
}
