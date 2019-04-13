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
    @objc dynamic var volumes: String = "empty"

    func setProperties(name: String,
                       prodList: [String],
                       receipttext: String,
                       regex: String,
                       volumes: String) {
        self.name = name
        var prodListString = ""
        prodList.forEach { (prod) in
            prodListString.append("\(prod);")
        }
        self.products = prodListString
        self.receipt = receipttext
        self.regexText = regex
        self.volumes = volumes
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
    
    func getVolumesList() -> [Double] {
        let res = self.volumes.components(separatedBy: ";")
        var result: [Double] = []
        res.forEach { (prod) in
            if !prod.isEmpty {
                if let doubleValue = Double(prod) {
                    result.append(doubleValue)
                }
            }
        }
        return result
    }
    
    func getRegexesList() -> [String] {
        var result = self.regexText.components(separatedBy: ";")
        result.forEach { (prod) in
            if prod.isEmpty {
                if let index = result.firstIndex(of: prod) {
                    result.remove(at: index)
                }
            }
        }
        return result
    }
    
    public static func generateList() {
        let realm = try! Realm()
        let list = realm.objects(Receipt.self)
        if list.isEmpty {
            let receipt = Receipt()
            let prodList: [String] = ["яйцо",
                                      "масло",
                                      "сковорода"]
            let receiptText = "кекус"
            let regex = "яйц;масл;сковор"
            let volumes = [100,
                           150,
                           1000]
            var volumesString: String = ""
            volumes.forEach { vol in
                volumesString.append("\(vol);")
            }
            receipt.setProperties(name: "Яичница",
                                  prodList: prodList,
                                  receipttext: receiptText,
                                  regex: regex,
                                  volumes: volumesString)
            try! realm.write {
                realm.add(receipt)
            }
        }
    }
}
