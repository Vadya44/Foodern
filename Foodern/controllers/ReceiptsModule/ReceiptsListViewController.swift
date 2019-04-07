//
//  ReceiptsListViewController.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 06/04/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit
import RealmSwift

struct ReceiptDescr {
    let percentage: Double
    let productItems: [ProductItem]
    let receipt: Receipt
    
    init(perc: Double, rec: Receipt, products: [ProductItem]) {
        self.percentage = perc
        self.receipt = rec
        self.productItems = products
    }
}


class ReceiptsListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [ReceiptDescr] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        // TODO: Make in background
        self.createReceiptList()
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addReceiptButtonClicked(_ sender: Any) {
        
    }
}

extension ReceiptsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptTableViewCell", for: indexPath) as! ReceiptTableViewCell
        cell.configure(recDescr: self.dataSource[indexPath.row])
        return cell
    }
    
    
}

extension ReceiptsListViewController {
    private func createReceiptList() {
        let myProducts = try! Realm().objects(ProductItem.self)
        let receipts = try! Realm().objects(Receipt.self)
        
        
        receipts.forEach { (receipt) in
            let prodList = receipt.getProductsList()
            var resultArray: [ProductItem] = []
            prodList.forEach({ (product) in
                myProducts.forEach({ (myProd) in
                    if myProd.name.contains(product.description) {
                        resultArray.append(myProd)
                    }
                })
            })
            let receiptDescr = ReceiptDescr(perc: (Double)(resultArray.count)/(Double)(prodList.count)*100,
                                            rec: receipt,
                                            products: resultArray)
            dataSource.append(receiptDescr)
        }
    }
}
