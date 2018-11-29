//
//  ViewController.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 22/11/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import UIKit

import RealmSwift

class FoodTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    let realm = try! Realm()
    let results = try! Realm().objects(ProductItem.self).sorted(byKeyPath : "name")
    var notificationToken: NotificationToken?
    
    var delegate : FoodTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.notificationToken = results.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self.tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the TableView
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
                break
            case .error(let err):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(err)")
                break
            }
        }
    }

    @IBAction func SlideBarTapped(_ sender: Any) {
        delegate?.toggleLeftPanel?()
    }
    
}


extension FoodTableViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChoosingCategoryCell", for: indexPath) as! ChoosingCategoryCell
            cell.makeRecognizer()
            return cell
        } else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductItemCell", for: indexPath) as! ProductItemCell
            cell.nameLabel.text = results[indexPath.row - 1].name
            return cell
        }
    }
    
    
}

extension FoodTableViewController : SidePanelViewControllerDelegate {
    func didSelectItem(_ item : SideMenuItem) {
        print(item.name)
        delegate?.collapseSidePanels?()
    }
}

extension FoodTableViewController {
    
}
