//
//  UIColor+ColorByPercentage.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 06/04/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//
import UIKit

extension UIColor {
    public static func takeColorByPercentage(percetange: CGFloat) -> UIColor {
        let red = 255 - (255 * (percetange / 100.0))
        let green = 255 * (percetange / 100.0)
        let blue = 0.0
        return UIColor(displayP3Red: red, green: green, blue: CGFloat(blue), alpha: 1.0)
    }
}
