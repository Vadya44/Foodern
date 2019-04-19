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
    @IBOutlet weak var mealsSearchBar: UISearchBar!
    @IBOutlet weak var redItemButton: UIBarButtonItem!
    @IBOutlet weak var usualItemsButton: UIBarButtonItem!
    
    var filteredResults = [ProductItem]()
    var isUsual = true
    
    let results = try! Realm().objects(ProductItem.self)
    var pickedResults = try! Realm().objects(Category.self)
    
    var notificationToken: NotificationToken?
    var searchText : String = ""
    var pickedCategories : [Bool] = []
    
    var delegate : FoodTableViewControllerDelegate?
    
    public func checkRefresh() {
        if self.pickedCategories.count != self.pickedResults.count {
            self.pickedCategories.removeAll()
            pickedResults.forEach { (_) in
                pickedCategories.append(true)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        ProductItem.writeArrayToJson(array: Array(self.results))
        self.configureState()
    }
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickedCategories.removeAll()
        pickedResults.forEach { (_) in
            pickedCategories.append(true)
        }
        
        self.mealsSearchBar.delegate = self
        
        self.notificationToken = pickedResults.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self.sortResults()
                self.tableView.reloadData()
                break
            case .update(_, _, _, _):
                // Query results have changed, so apply them to the TableView
                self.checkRefresh()
                self.pickedCategories.removeAll()
                self.pickedResults.forEach { (_) in
                    self.pickedCategories.append(true)
                }
                self.sortResults()
                break
            case .error(let err):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(err)")
                break
            }
        }
        self.notificationToken = results.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self.sortResults()
                self.tableView.reloadData()
                break
            case .update(_,  _,  _,  _):
                // Query results have changed, so apply them to the TableView
                self.sortResults()
                self.tableView.reloadData()
                break
            case .error(let err):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(err)")
                break
            }
        }
        sortResults()
    }

    @IBAction func SlideBarTapped(_ sender: Any) {
        self.view.endEditing(true)
        delegate?.toggleLeftPanel?()
    }
    @IBAction func usualButtonItemClicked(_ sender: Any) {
        self.hideKeyboard()
        self.usualItemsButton.isEnabled = false
        self.redItemButton.isEnabled = true
        self.isUsual = true
        self.sortResults()
    }
    @IBAction func redButtonItemClicked(_ sender: Any) {
        self.hideKeyboard()
        self.redItemButton.isEnabled = false
        self.usualItemsButton.isEnabled = true
        self.isUsual = false
        self.sortResults()
    }
    
}


extension FoodTableViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + filteredResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.hideKeyboard()
        if indexPath.row == 0 {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "CategoriesPickerViewController") as! CategoriesPickerViewController
            newViewController.initPicked(arr: pickedCategories, delegateTV: self)
            self.present(newViewController, animated: true, completion: nil)
        } else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let editViewController = storyBoard.instantiateViewController(withIdentifier: "AddProductViewController") as!
                AddProductViewController
            editViewController.initForEditing(item: filteredResults[indexPath.row - 1])
            self.present(editViewController, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChoosingCategoryCell", for: indexPath) as! ChoosingCategoryCell
            return cell
        } else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProductItemCell", for: indexPath) as! ProductItemCell
            cell.configure(product: filteredResults[indexPath.row - 1])
            return cell
        }
    }
    
    
}

extension FoodTableViewController : SidePanelViewControllerDelegate {
    func didSelectItem(_ number : Int) {
        delegate?.collapseSidePanels?()
        if number == 1 {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReceiptsListViewController") as? ReceiptsListViewController
            {
                self.present(vc, animated: true, completion: nil)
            }
            
        }
        if number == 2 {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateNotifyViewController") as? CreateNotifyViewController
            {
                self.present(vc, animated: true, completion: nil)
            }
            
        }
        if number == 3 {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoriesViewController") as? CategoriesViewController
            {
                vc.initVC(vc: self)
                self.present(vc, animated: true, completion: nil)
            }
            
        }
        if number == 4 {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutAppViewController") as? AboutAppViewController
            {
                self.present(vc, animated: true, completion: nil)
            }
            
        }
        if number == 5 {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QRCodeScannerViewController") as? QRCodeScannerViewController
            {
                self.present(vc, animated: true, completion: nil)
            }
            
        }
    }
}

extension FoodTableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
    }
}
extension FoodTableViewController : CategoriesPickerDelegate {
    func reloadPicked(_ array : [Bool]) {
        self.pickedCategories = array
        sortResults()
    }
}

extension FoodTableViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        sortResults()
    }
    
    func sortResults() {
        pickedResults = try! Realm().objects(Category.self)
        
        self.filteredResults = Array(results)
        if !isUsual {
            self.filteredResults = self.filteredResults.filter { (item) -> Bool in
                return item.getTempOfInitial() <= 30.0
            }
            self.tableView.reloadData()
            return
        }
        
        var picked = [Category]()
        if pickedCategories.count >= 1 {
            for i in 0...pickedCategories.count - 1 {
                if (pickedCategories[i]) {
                    picked.append(pickedResults[i])
                }
            }
        }
        
        
        
        filteredResults = searchText.isEmpty ? filteredResults : filteredResults.filter({ (item : ProductItem) -> Bool in
            
            return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        
        if (picked.count == pickedResults.count) {
            tableView.reloadData()
            return
            
        } else if picked.count == 0 {
            filteredResults = filteredResults.filter({ (item : ProductItem) -> Bool in
                return item.tempCategories.count == 0
            })
            tableView.reloadData()
            return
        } else {
            filteredResults = filteredResults.filter({ (item : ProductItem) -> Bool in
                let itemCats = item.tempCategories
                for choosedCats in picked {
                    if itemCats.contains(Substring(choosedCats.stringName)) {
                        return true
                    }
                }
                return false
            })
            
        }
        
        
        tableView.reloadData()
    }
    private func configureState() {
        self.usualItemsButton.isEnabled = false
        self.redItemButton.isEnabled = true
        self.isUsual = true
        self.sortResults()
    }
    
}
