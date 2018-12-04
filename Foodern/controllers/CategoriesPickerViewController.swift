//
//  CategoriesPickerViewController.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 02/12/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class CategoriesPickerViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let results = try! Realm().objects(Category.self)
    var picked : [Bool] = []
    var notificationToken: NotificationToken?
    var delegate : CategoriesPickerDelegate?
    
    func initPicked(arr : [Bool], delegateTV : CategoriesPickerDelegate) {
        self.picked = arr
        self.delegate = delegateTV
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = #colorLiteral(red: 0.8039215686, green: 0.9333333333, blue: 0.9725490196, alpha: 1)
        tableView.clipsToBounds = true
        
        for _ in 0...self.results.count {
            picked.append(false)
        }
        
        self.notificationToken = results.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self.tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the TableView
                self.picked.removeAll()
                for _ in 0...self.results.count {
                    self.picked.append(false)
                }
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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        delegate?.reloadPicked(picked)
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CategoriesPickerViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableViewCell", for: indexPath) as! CategoriesTableViewCell
        cell.categoryNameLabel.text = results[indexPath.row].stringName
        if (picked[indexPath.row]) {
            cell.pick()
        }
        else {
            cell.unPick()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        picked[indexPath.row] = !picked[indexPath.row]
        tableView.reloadData()
    }
}

protocol CategoriesPickerDelegate {
    func reloadPicked(_ array : [Bool])
}
