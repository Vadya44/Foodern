//
//  SideItemCell.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 22/11/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import UIKit

class SideItemCell : UITableViewCell {
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    func configureItem(_ item : SideMenuItem) {
        itemLabel.text = item.name
        
        if item.image != nil {
            itemImageView.image = item.image?.withRenderingMode(.alwaysTemplate)
            itemImageView.tintColor = .white
        }
    }
}

extension UIImage{
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
}
