//
//  ReceiptTableViewCell.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 06/04/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit

class ReceiptTableViewCell: UITableViewCell {
    @IBOutlet weak var receiptName: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    private var receiptDescr: ReceiptDescr?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.receiptName.text = self.receiptDescr?.receipt.name
        self.percentageLabel.text = self.receiptDescr?.percentage.description
        //self.percentageLabel.textColor = 
    }
    
    public func configure(recDescr: ReceiptDescr) {
        self.receiptDescr = recDescr
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
