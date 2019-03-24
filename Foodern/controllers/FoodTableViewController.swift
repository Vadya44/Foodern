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
    
    var filteredResults = [ProductItem]()
    
    let results = try! Realm().objects(ProductItem.self)
    let pickedResults = try! Realm().objects(Category.self)
    
    var notificationToken: NotificationToken?
    var searchText : String = ""
    var pickedCategories : [Bool] = []
    
    var delegate : FoodTableViewControllerDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        ProductItem.writeArrayToJson(array: Array(self.results))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0...self.pickedResults.count - 1 {
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
                self.pickedCategories.removeAll()
                for _ in 0...self.pickedResults.count - 1 {
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
        delegate?.toggleLeftPanel?()
    }
    
}


extension FoodTableViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + filteredResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CreateNotifyViewController") as? CreateNotifyViewController
            {
                self.present(vc, animated: true, completion: nil)
            }
            
        }
        if number == 2 {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AboutAppViewController") as? AboutAppViewController
            {
                self.present(vc, animated: true, completion: nil)
            }
            
        }
        if number == 3 {
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
        
        filteredResults = Array(results)
        
        print(filteredResults)
        
        var picked = [Category]()
        for i in 0...pickedCategories.count - 1 {
            if (pickedCategories[i]) {
                picked.append(pickedResults[i])
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
                print("itemcats = \(itemCats)")
                for choosedCats in picked {
                    print(choosedCats)
                    if itemCats.contains(Substring(choosedCats.stringName)) {
                        return true
                    }
                }
                return false
            })
            
        }
        
        
        tableView.reloadData()
    }
    
}
