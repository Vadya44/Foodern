//
//  Receipt.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 03/04/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import RealmSwift
import Realm
import UIKit

@objcMembers class Receipt : Object, Codable {
    @objc dynamic var name : String = "empty"
    @objc dynamic var products : String = "empty"
    @objc dynamic var receipt : String = "empty"
    @objc dynamic var regexText: String = "empty"
    
    func setProperties(name: String,
                       prodList: [String],
                       receipttext: String,
                       regex: String) {
        self.name = name
        var prodListString = ""
        prodList.forEach { (prod) in
            prodListString.append("\(prod);")
        }
        self.products = prodListString
        self.receipt = receipttext
        self.regexText = regex
    }
    
    func getProductsList() -> [String] {
        var result = self.products.components(separatedBy: ";")
        result.forEach { (prod) in
            if prod.isEmpty {
                if let index = result.firstIndex(of: prod) {
                    result.remove(at: index)
                }
            }
        }
        return result
    }
}
