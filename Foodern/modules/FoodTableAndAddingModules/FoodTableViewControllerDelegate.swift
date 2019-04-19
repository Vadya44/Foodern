//
//  FoodTableViewControllerDelegate.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 22/11/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import UIKit

@objc
protocol FoodTableViewControllerDelegate {
    @objc optional func toggleLeftPanel()
    @objc optional func collapseSidePanels()
}
