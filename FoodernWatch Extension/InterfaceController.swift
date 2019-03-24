//
//  InterfaceController.swift
//  FoodernWatch Extension
//
//  Created by Вадим Гатауллин on 17/03/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    var array: [ProductItem] = []
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        array = ProductItem.allProductItemMocked()
        
        self.tableView.setNumberOfRows(array.count, withRowType: "row")
        for index in 0..<tableView.numberOfRows {
            guard let controller = tableView.rowController(at: index) as? rowConroller else { continue }
            
            controller.product = array[index]
        }
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
