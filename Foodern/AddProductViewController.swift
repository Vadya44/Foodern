//
//  AddProductViewController.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 26/11/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class AddProductViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var volumeTextField: UITextField!
    @IBOutlet weak var choosingButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let variablesForPick = ["гр.", "кг.", "мл.", "л.", "другое"]
    var tempNumberOfVariable : Int = 0
    
    
    @IBAction func choosingButtonClicked(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "VariablePickerViewController") as! VariablePickerViewController
        newViewController.delegate = self
        newViewController.currentRow = tempNumberOfVariable
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    let results = try! Realm().objects(Category.self)
    var notificationToken: NotificationToken?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        self.volumeTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        
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
    
    @IBAction func nameTFReturn(_ sender: Any) {
        nameTextField.resignFirstResponder()
        volumeTextField.becomeFirstResponder()
    }
    
    @IBAction func volumeTFReturn(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func doneButtonClicked(_ sender: Any) {
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension AddProductViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryPickerCell", for: indexPath) as! CategoryPickerCell
        cell.categoryLabel.text = results[indexPath.row].stringName
        return cell
    
    }
}


extension AddProductViewController : AddProductViewControllerDelegate {
    func newVariableValue(_ newValue: Int) {
        self.tempNumberOfVariable = newValue
        self.choosingButton.titleLabel?.text = variablesForPick[tempNumberOfVariable]
    }
}

