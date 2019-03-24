//
//  SideMenuItem.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 22/11/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import UIKit

struct SideMenuItem {
    let name : String
    let image : UIImage?

    init(name : String, image : UIImage?) {
        self.name = name
        self.image = image
    }
    
    static func allItems() -> [SideMenuItem] {
        return [
        SideMenuItem(name: "Мои Запасы", image: UIImage(named: "fridge")),
        //SideMenuItem(name: "Рецепты", image: UIImage(named: "receipts")),
        SideMenuItem(name: "Запланировать покупку", image: UIImage(named: "createNotify")),
        //SideMenuItem(name: "Настройки", image : UIImage(named: "settings")),
        SideMenuItem(name: "О Программе", image : UIImage(named: "appInfo")),
        SideMenuItem(name: "Добавить из чека", image: UIImage(named: "check"))]
    }
}
