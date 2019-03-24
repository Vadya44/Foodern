//
//  ProductItem.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 28/11/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import RealmSwift
import Realm
import Foundation
import UIKit

@objcMembers class ProductItem : Object, ProductVolume, Codable {
    @objc dynamic var name : String = "empty"

    @objc dynamic var tempCount : Int = 1
    @objc dynamic var fullCount : Int = 1
    
    @objc dynamic var tempVolume : Double = 1
    @objc dynamic var fullVolume : Double = 1
    
    @objc dynamic var isLiquid = false
    @objc dynamic var isHaveWeight = false
    @objc dynamic var isCountable = false
    
    @objc dynamic var tempPercent : Double = 1
    @objc dynamic var tempCategories : String = ""
    
    func setProperties(name: String, tempVol : Double?, fullVolume : Double?, isLiquid : Bool?, isHaveW : Bool?, tempCapacity : Double?, isCountable : Bool?, tempC : Int?, fullC : Int?, categories : [Category]?) {
        self.name = name
        self.tempPercent = tempCapacity ?? self.tempPercent
        if (tempVol != nil) {
            self.tempVolume = tempVol!
        }
        if fullVolume != nil {
            self.fullVolume = fullVolume!
        }
        if (isLiquid != nil) {
            self.isLiquid = isLiquid!
        }
        if (isHaveW != nil) {
            self.isHaveWeight = isHaveW!
        }
        if (isCountable != nil) {
            self.isCountable = isCountable!
        }
        if (tempC != nil) {
            self.tempCount = tempC!
        }
        if (fullC != nil) {
            self.fullCount = fullC!
        }
        if let Productcategories = categories {
            for cat in Productcategories {
                self.tempCategories.append("\(cat.stringName);")
            }
        }
    }
    
    
    func getTempVolume() -> Double {
        return tempVolume
    }
    
    func setTempVolume(newVolume : Double) {
        self.tempVolume = newVolume
        self.tempPercent = tempVolume / fullVolume
    }
    
    func setTempCount(newCount : Int) {
        self.tempCount = newCount
        self.tempPercent = (Double)(tempCount) / (Double)(fullCount)
    }
    
    func getTempPercent() -> Double {
        return tempPercent
    }
    
    func getVolumeString() -> String {
        if (isLiquid) {
            return "\(tempVolume) л."
        } else if (isHaveWeight) {
            return "\(tempVolume) гр."
        } else if (isCountable) {
            return "\(tempCount) шт."
        } else {
            return "\(tempVolume)"
        }
    }
    
    func getCategories() -> String {
        return self.tempCategories
    }
    

    public static func allProductItemMocked() -> [ProductItem] {
        var kek: [ProductItem] = []
        
        let kek1 = ProductItem()
        let kek2 = ProductItem()
        let kek3 = ProductItem()
        let kek4 = ProductItem()
        let kek5 = ProductItem()
        let kek6 = ProductItem()
        let kek7 = ProductItem()
        let kek8 = ProductItem()
        let kek9 = ProductItem()
        kek2.setProperties(name: "Морковь", tempVol: 2.0, fullVolume: nil, isLiquid: nil, isHaveW: nil, tempCapacity: nil, isCountable: nil, tempC: nil, fullC: nil, categories: nil)
        kek1.setProperties(name: "Картофель", tempVol: 3.1, fullVolume: nil, isLiquid: nil, isHaveW: nil, tempCapacity: nil, isCountable: nil, tempC: nil, fullC: nil, categories: nil)
        kek3.setProperties(name: "Огурец", tempVol: 1.2, fullVolume: nil, isLiquid: nil, isHaveW: nil, tempCapacity: nil, isCountable: nil, tempC: nil, fullC: nil, categories: nil)
        kek4.setProperties(name: "Куринное филе", tempVol: 1.0, fullVolume: nil, isLiquid: nil, isHaveW: nil, tempCapacity: nil, isCountable: nil, tempC: nil, fullC: nil, categories: nil)
        kek5.setProperties(name: "Корнишон", tempVol: 1.5, fullVolume: nil, isLiquid: nil, isHaveW: nil, tempCapacity: nil, isCountable: nil, tempC: nil, fullC: nil, categories: nil)
        kek6.setProperties(name: "Помидоры", tempVol: 16.2, fullVolume: nil, isLiquid: nil, isHaveW: nil, tempCapacity: nil, isCountable: nil, tempC: nil, fullC: nil, categories: nil)
        kek7.setProperties(name: "Вода", tempVol: 87.0, fullVolume: nil, isLiquid: nil, isHaveW: nil, tempCapacity: nil, isCountable: nil, tempC: nil, fullC: nil, categories: nil)
        kek8.setProperties(name: "Молоко", tempVol: 71.1, fullVolume: nil, isLiquid: nil, isHaveW: nil, tempCapacity: nil, isCountable: nil, tempC: nil, fullC: nil, categories: nil)
        kek9.setProperties(name: "Сок яблочный", tempVol: 112.2, fullVolume: nil, isLiquid: nil, isHaveW: nil, tempCapacity: nil, isCountable: nil, tempC: nil, fullC: nil, categories: nil)
        
        
        kek.append(kek1)
        kek.append(kek2)
        kek.append(kek3)
        kek.append(kek4)
        kek.append(kek5)
        kek.append(kek6)
        kek.append(kek7)
        kek.append(kek8)
        kek.append(kek9)
        return kek
    }
    
    public static func allProductItem() -> [ProductItem] {
        var flights: [ProductItem] = []

        var sharedFilePath: String?
        let fileManager = FileManager.default
        
        let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.vadya44.share")!
        
        let dirPath = sharedContainer.path
        sharedFilePath = (NSURL(fileURLWithPath: dirPath).appendingPathComponent(
            "Products.json")?.path)
        
        var txt: Data?
        
        if fileManager.fileExists(atPath: sharedFilePath!) {
            let databuffer = fileManager.contents(atPath: sharedFilePath!)
            txt = databuffer
        }
        guard let data = txt else { return flights }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String: Any]]
            json.forEach({ (dict: [String: Any]) in
                flights.append(ProductItem(dictionary: dict))
            })
        } catch let error as NSError {
            print(error)
        }

//        return flights
        return flights
    }
    
    public static func writeArrayToJson(array: [ProductItem]) {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(array)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        
//        guard let path = Bundle.main.path(forResource: "Products", ofType: "json") else {return}
        let data = json!.data(using: String.Encoding.utf8)!
//        if let file = FileHandle(forWritingAtPath:path) {
//            file.write(data)
//        }
//        print(json!)
        
        var sharedFilePath: String?
        let fileManager = FileManager.default
        
        let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.vadya44.share")!
        
        let dirPath = sharedContainer.path
        sharedFilePath = (NSURL(fileURLWithPath: dirPath).appendingPathComponent(
            "Products.json")?.path)
        
        if fileManager.fileExists(atPath: sharedFilePath!) {
                    if let file = FileHandle(forWritingAtPath:sharedFilePath!) {
                        file.write(data)
                    }
        } else {
            fileManager.createFile(atPath: sharedFilePath!, contents: data, attributes: nil)
        }
        
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"]! as! String
        let tempCount = dictionary["tempCount"]! as! Int
        let fullCount = dictionary["fullCount"]! as! Int
        let tempVolume = dictionary["tempVolume"]! as! Double
        let fullVolume = dictionary["fullVolume"]! as! Double
        let isLiquid = dictionary["isLiquid"]! as! Bool
        let isHaveWeight = dictionary["isHaveWeight"]! as! Bool
        let isCountable = dictionary["isCountable"]! as! Bool
        
        self.init()
        self.setProperties(name: name, tempVol: tempVolume, fullVolume: fullVolume, isLiquid: isLiquid, isHaveW: isHaveWeight, tempCapacity: nil, isCountable: isCountable, tempC: tempCount, fullC: fullCount, categories: nil)
        //self.setPro
    }

}

extension String {
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
}
