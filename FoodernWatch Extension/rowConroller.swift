//
//  rowConroller.swift
//  FoodernWatch Extension
//
//  Created by Вадим Гатауллин on 24/03/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import WatchKit

class rowConroller: NSObject {
    var product: ProductItem? {
        didSet {
            self.titleLabel.setText(product?.name)
            self.subtitleLabel.setText(product?.getTempVolume().description)
        }
    }
    
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var subtitleLabel: WKInterfaceLabel!
}
