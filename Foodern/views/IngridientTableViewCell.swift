//
//  IngridientTableViewCell.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 06/04/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit

class IngridientTableViewCell: UITableViewCell {

    @IBOutlet weak var myIngridientLabel: UILabel!
    @IBOutlet weak var ingridientName: UILabel!
    
    private var ingrName: String?
    private var vol: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.myIngridientLabel.text = self.vol
        self.ingridientName.text = self.ingrName
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with ingridientName: String, product: ProductItem) {
        self.vol = "\(product.name) \(product.getVolumeString())"
        self.ingrName = ingridientName
    }

}
