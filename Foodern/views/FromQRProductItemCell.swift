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
    @IBOutlet weak var volumeLabel: UILabel!
    
    private weak var item: ProductItem?
    private weak var parent: UIViewController?
    private var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func pickCategoryButtonTapped(_ sender: Any) {
        guard let object = self.item,
            let uivc = parent else {
                return
        }
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editViewController = storyBoard.instantiateViewController(withIdentifier: "AddProductViewController") as!
        AddProductViewController
        editViewController.initForEditing(item: object)
        editViewController.configureWithVC(vc: parent!, index: index!)
        uivc.present(editViewController, animated: true, completion: nil)
    }
    
    func configure(object : ProductItem, viewController: UIViewController, index: Int) {
        self.item = object
        self.parent = viewController
        self.nameLabel.text = object.name
        self.volumeLabel.text = object.getVolumeString()
        self.index = index
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
