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
        try! realm.write {
            realm.delete(list)
        }
        if list.isEmpty {
            let receipt = Receipt()
            var prodList: [String] = ["Яйцо куриное",
                                      "Соль",
                                      "Растительное масло"]
            var receiptText = "1. На сковороде разогреть масло, выпустить яйца, стараясь не разорвать оболочки желтков, посолить, подержать сковороду 1–2 минуты на плите, а затем поставить на 3–4 минуты в горячий духовой шкаф.\n\n2. Как только белок примет молочно-белый цвет, яичницу надо подать на той же сковороде или на подогретой тарелке."
            var regex = "яйц;соль;масл"
            var volumes = [2,
                           0,
                           1]
            var volumesString: String = ""
            volumes.forEach { vol in
                volumesString.append("\(vol);")
            }
            receipt.setProperties(name: "Яичница-глазунья",
                                  prodList: prodList,
                                  receipttext: receiptText,
                                  regex: regex,
                                  volumes: volumesString)
            
            let receipt2 = Receipt()
            prodList = ["Cвежая молодая капуста",
                        "Огурцы",
                        "Зелень укропа",
                        "Чеснок - 2-3 зубчика",
                        "Соль",
                        "сметана 25% или ещё жирней",
                        "Черный перец"]
            receiptText = "Люблю такие салаты, простые, овощные. Весной самое то!\n\nИтак,начнём!\n\nКапусту нашинковать тонкой соломкой, добавить щепотку соли по вкусу, слегка её обмять. Огурцы нарезать полукольцами, мелко нарезать зелень укропа, измельчить чеснок или пропустить через пресс. Все нарезанные овощи отправить к капусте, добавить по вкусу черный перец и соль ( если потребуется). Заправить сметаной, перемешать.\n\nСалат готов!\n\nПриятного аппетита!"
            regex = "капуст;огурц;укроп;чесно;сол;сметан;перец"
            volumes = [400,
                       2,
                       0,
                       1,
                       0,
                       0,
                       0]
            volumesString = ""
            volumes.forEach { vol in
                volumesString.append("\(vol);")
            }
            receipt2.setProperties(name: "Весенний салат",
                                  prodList: prodList,
                                  receipttext: receiptText,
                                  regex: regex,
                                  volumes: volumesString)
            
            let receipt3 = Receipt()
            prodList = ["Рыба 1 шт",
                        "Масло 2 ст.л",
                        "Соль 5 гр",
                        "Помидор 1 шт",
                        "Специя 3 гр"]
            receiptText = "Такую РЫБУ хочется есть еще и еще! И готовится проще не придумаешь!\n\nРыбу почистить помыть и порезать на куски. Теперь посолить и специи по вкусу также добавить масло. Помидор нарезать кружочками.\n\nБерём тарелку для микроволновки на дно уложить Помидор, а сверху кусочки рыбы. Отправить в микроволновку на всю мощность на 7 минут.\n\nРыба супер вкусная получается"
            regex = "рыб;масл;сол;помид;специ"
            volumes = [1,
                       1,
                       0,
                       1,
                       0]
            volumesString = ""
            volumes.forEach { vol in
                volumesString.append("\(vol);")
            }
            receipt3.setProperties(name: "Скумбрия за 10 минут в микроволновке",
                                  prodList: prodList,
                                  receipttext: receiptText,
                                  regex: regex,
                                  volumes: volumesString)
            
            let receipt4 = Receipt()
            prodList = ["300 г. фарша",
                        "300 г. макаронных изделий",
                        "200 г. консервированной кукурузы",
                        "5-6 ст.л. соевого соуса",
                        "2 ст.л. растительного масла для жарки"]
            receiptText = "Отварить макароны до полуготовности (7 минут примерно).\n\nОбжарить фарш, добавить немного воды и протушить 10 минут.\n\nК готовому фаршу выложить макароны , кукурузу и соевый соус.\n\nХорошо перемешать."
            regex = "фарш;макарон;кукур;соев;растит"
            volumes = [300,
                       0,
                       0,
                       0,
                       0]
            volumesString = ""
            volumes.forEach { vol in
                volumesString.append("\(vol);")
            }
            receipt4.setProperties(name: "Макароны по-флотски",
                                  prodList: prodList,
                                  receipttext: receiptText,
                                  regex: regex,
                                  volumes: volumesString)
            
            
            let receipt5 = Receipt()
            prodList = ["Картофель - 250 г.",
                        "Мука - 1-2 ст.л.",
                        "Яйцо - 1 шт.",
                        "Сметана - 2 ст.л.",
                        "Соль"]
            receiptText = "Картофель чистим, нарезаем кусочками и отвариваем в подсоленной воде.\n\nКартофельный отвар сливаем, оставив отдельно 20 мл.\n\nКартофель разминаем, добавляем картофельный отвар, яйцо, сметану, муку, перемешиваем.\n\nОбжариваем на растительном масле с двух сторон до золотистого цвета."
            regex = "карто;мук;яйц;сметан;соль"
            volumes = [250,
                       1,
                       1,
                       0,
                       0]
            volumesString = ""
            volumes.forEach { vol in
                volumesString.append("\(vol);")
            }
            receipt5.setProperties(name: "Картофельные оладьи из пюре",
                                  prodList: prodList,
                                  receipttext: receiptText,
                                  regex: regex,
                                  volumes: volumesString)
            
            try! realm.write {
                realm.add(receipt)
                realm.add(receipt2)
                realm.add(receipt3)
                realm.add(receipt4)
                realm.add(receipt5)
            }
        }
    }
}
