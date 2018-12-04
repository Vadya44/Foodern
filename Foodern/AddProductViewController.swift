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
    
    var pickedCategories : [Bool] = []
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0...self.results.count {
            pickedCategories.append(false)
        }
        
        
        self.nameTextField.delegate = self
        self.volumeTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
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
    
    @IBAction func categoriesChoosingButtonClicked(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "CategoriesPickerViewController") as! CategoriesPickerViewController
        newViewController.initPicked(arr: pickedCategories, delegateTV: self)
        self.present(newViewController, animated: true, completion: nil)
    }
}



extension AddProductViewController : AddProductViewControllerDelegate {
    func newVariableValue(_ newValue: Int) {
        self.tempNumberOfVariable = newValue
        self.choosingButton.titleLabel?.text = variablesForPick[tempNumberOfVariable]
    }
}

extension AddProductViewController : CategoriesPickerDelegate {
    func reloadPicked(_ array : [Bool]) {
        self.pickedCategories = array
    }
}
