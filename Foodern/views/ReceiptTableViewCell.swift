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
    }
    
    public func configure(recDescr: ReceiptDescr) {
        self.receiptDescr = recDescr
        self.receiptName.text = self.receiptDescr?.receipt.name
        self.percentageLabel.text = "Количество имеющихся ингредиентов: \((self.receiptDescr?.productItems.count ?? 0).description) из \((self.receiptDescr?.receipt.getProductsList().count ?? 0).description)"
        //self.percentageLabel.textColor = UIColor.takeColorByPercentage(percetange: CGFloat(self.receiptDescr!.percentage))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}
