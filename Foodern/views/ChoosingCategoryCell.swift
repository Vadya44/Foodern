//
//  ChoosingCategoryCell.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 26/11/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import  UIKit

class ChoosingCategoryCell : UITableViewCell {
    

    @IBOutlet weak var cellStackView: UIView!
    
    func makeRecognizer() {
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ChoosingCategoryCell.tapDetected))
        cellStackView.isUserInteractionEnabled = true
        cellStackView.addGestureRecognizer(singleTap)
    }
    
    @objc func tapDetected() {
        print("Imageview Clicked")
    }
}
