//
//  ReceiptTextViewController.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 06/04/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit

class ReceiptTextViewController: UIViewController {
    @IBOutlet weak var receiptTextView: UITextView!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    
    private var receipt: Receipt?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navBarTitle.title = receipt?.name
        self.receiptTextView.text = receipt?.receipt
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }

    public func setReceipt(rec: Receipt) {
        self.receipt = rec
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
