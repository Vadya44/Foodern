//
//  FromQRProductItemCell.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 24/01/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit

class FromQRProductItemCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pickCategoryButton: UIButton!
    @IBOutlet weak var cellContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func pickCategoryButtonTapped(_ sender: Any) {
        
    }
    
    func configure(name : String) {
        nameLabel.text = name
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
