//
//  ProductItem.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 28/11/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import RealmSwift
import Realm

@objcMembers class ProductItem : Object, ProductVolume {
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
        self.tempPercent = tempCapacity!
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
}
