//
//  CategoriesViewController.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 16/04/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

class CategoriesViewController: UIViewController {
    @IBOutlet var newCategoryView: UIView!
    @IBOutlet weak var newCategoryTextField: UITextField!
    @IBOutlet weak var newCategorySaveButton: UIButton!
    @IBOutlet weak var categoriesTableView: UITableView!
    
    var categoryList: [Category] = []
    var blurEffectView: UIView!
    let realm = try! Realm()
    public var vc: FoodTableViewController!
    
    private func refreshTableView() {
        categoryList = Array(self.realm.objects(Category.self))
        self.categoriesTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoriesTableView.delegate = self
        self.categoriesTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.refreshTableView()
    }
    

    @IBAction func newCatButtonClicked(_ sender: Any) {
        if let text = self.newCategoryTextField.text {
            if !text.isEmpty {
                let category = Category()
                category.stringName = text
                try! self.realm.write {
                    self.realm.add(category)
                    self.vc.checkRefresh()
                }
            }
        }
        
        self.blurEffectView.removeFromSuperview()
        self.newCategoryView.removeFromSuperview()
        self.refreshTableView()
    }
    
    public func initVC(vc: FoodTableViewController) {
        self.vc = vc
    }
    
    @IBAction func newCatCancelButtonClicked(_ sender: Any) {
        self.blurEffectView.removeFromSuperview()
        self.newCategoryView.removeFromSuperview()
        self.refreshTableView()
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func newCategoryButtonClicked(_ sender: Any) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        self.blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurEffectView.frame = view.bounds
        self.blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.newCategoryView.frame = CGRect(origin: CGPoint(x: view.bounds.maxX/2 - self.newCategoryView.bounds.maxX / 2, y: view.bounds.maxY/2.5 - self.newCategoryView.bounds.maxY / 2), size: self.newCategoryView.bounds.size)
        self.view.addSubview(self.blurEffectView)
        self.view.addSubview(self.newCategoryView)
    }
    
}
extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! self.realm.write {
                self.realm.delete(self.categoryList[indexPath.row])
                self.vc.checkRefresh()
            }
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
        self.refreshTableView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        
        cell.nameLabel.text = self.categoryList[indexPath.row].stringName
        
        return cell
    }
    
    
}
