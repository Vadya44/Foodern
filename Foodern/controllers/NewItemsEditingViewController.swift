//
//  NewItemsEditingViewController.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 19/03/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class NewItemsEditingViewController: UIViewController {
    @IBOutlet weak var newItemsTableView: UITableView!
    
    public var dataSource: [ProductItem] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.newItemsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newItemsTableView.delegate = self
        self.newItemsTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didCancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didSaveAllButtonTapped(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(dataSource)
        }
        self.dismiss(animated: true, completion: {
            self.dismiss(animated: false, completion: nil)
        })
    }
    
    func removeItem(index: Int) {
        if self.dataSource.count > index {
            self.dataSource.remove(at: index)
        }
        self.newItemsTableView.reloadData()
    }

}

extension NewItemsEditingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FromQRProductItemCell", for: indexPath) as! FromQRProductItemCell
        cell.configure(object: dataSource[indexPath.row], viewController: self, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.newItemsTableView.reloadData()
        }
    }
    
}
