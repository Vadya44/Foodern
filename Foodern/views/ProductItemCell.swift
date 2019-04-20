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
        if !product.getVolumeString().isEmpty {
            self.capacityLabel.text = product.getVolumeString()
        }
        self.productImage.image = DataManager.getImage(imageName: product.id.description)
        if product.getTempOfInitial() <= 30.0 {
            self.containerView.backgroundColor = UIColor.init(displayP3Red: 255, green: 0, blue: 0, alpha: 0.1)
        } else if (product.getTempOfInitial() >= 70) {
            self.containerView.backgroundColor = UIColor.init(displayP3Red: 0, green: 255, blue: 0, alpha: 0.1)
        } else {
            self.containerView.backgroundColor = UIColor.init(displayP3Red: 255, green: 255, blue: 0, alpha: 0.1)
        }
    }
    
}
