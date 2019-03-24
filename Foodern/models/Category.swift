//
//  Category.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 28/11/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objcMembers class Category : Object {
    @objc dynamic var stringName : String = ""
    func equalTo(rhs: Category) -> Bool {
        return self.stringName == rhs.stringName
    }
    static func ==(lhs: Category, rhs: Category) -> Bool {
        return lhs.equalTo(rhs: rhs)
        
    }
}
