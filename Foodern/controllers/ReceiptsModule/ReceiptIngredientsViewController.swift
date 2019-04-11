//
//  ReceiptIngredientsViewController.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 06/04/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit

class ReceiptIngredientsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var receipt: ReceiptDescr?
    var receiptProductsList: [String] = []
    var myProdsForReceipts: [ProductItem?] = []
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.receiptProductsList = receipt!.receipt.getProductsList()
        var i = 0
        self.receiptProductsList.forEach { (prodFromRec) in
            self.myProdsForReceipts.append(nil)
            receipt?.productItems.forEach({ (myItem) in
                if myItem.name.lowercased().contains(prodFromRec.description.lowercased()) {
                    self.myProdsForReceipts[i] = myItem
                } else {
                }
                i = i + 1
            })
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.navBarTitle.title = receipt?.receipt.name
    }
    
    @IBAction func receiptTextButtonClicked(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "ReceiptTextViewController") as! ReceiptTextViewController
        newViewController.setReceipt(rec: self.receipt!.receipt)
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    public func setReceipt(rec: ReceiptDescr) {
        self.receipt = rec
    }

}

extension ReceiptIngredientsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.receipt!.receipt.getProductsList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngridientTableViewCell", for: indexPath) as! IngridientTableViewCell
        cell.configure(with: self.receiptProductsList[indexPath.row], product: self.myProdsForReceipts[indexPath.row])
        return cell
    }
    
    
}
