//
//  ProductItem.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 28/11/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import RealmSwift
import Realm

class ProductItem : Object, ProductVolume {
    @objc dynamic var name : String
    @objc dynamic var category : Category?

    @objc dynamic var tempCount : Int = 1
    @objc dynamic var fullCount : Int = 1
    
    @objc dynamic var tempVolume : Double = 1
    @objc dynamic var fullVolume : Double = 1
    
    @objc dynamic var isLiquid = false
    @objc dynamic var isHaveWeight = false
    @objc dynamic var isCountable = false
    
    @objc dynamic var tempPercent : Double = 1
    
    init(name: String, tempVol : Double?, fullVolume : Double?, isLiquid : Bool?, isHaveW : Bool?, tempCapacity : Double?, isCountable : Bool?, tempC : Int?, fullC : Int?, category : Category?) {
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
        if (category != nil) {
            self.category = category!
        }
        super.init()
    }
    
    required init() {
        self.name = "empty"
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        self.name = "empty"
        super.init()
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        self.name = "empty"
        super.init()
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
}
