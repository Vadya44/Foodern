//
//  notifyTableViewCell.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 24/03/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit

class notifyTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descrLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
