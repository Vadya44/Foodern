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

enum State {
    case editing
    case creating
    case editingNew
}

class AddProductViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var volumeTextField: UITextField!
    @IBOutlet weak var choosingButton: UIButton!
    
    @IBOutlet weak var navigationBarTitleChanger: UINavigationItem!
    
    var parentVC: NewItemsEditingViewController?
    var editingIndex: Int? = nil
    
    var currentState : State = .creating
    
    var picker = UIImagePickerController()
    
    var pickedCategories : [Bool] = []
    var editingItem : ProductItem? = nil
    
    var imageOfProduct: UIImage?
    
    let variablesForPick = ["гр.", "мл.", "шт.", "другое"]
    var tempNumberOfVariable : Int = 0
    
    
    @IBAction func choosingButtonClicked(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "VariablePickerViewController") as! VariablePickerViewController
        newViewController.delegate = self
        newViewController.currentRow = tempNumberOfVariable
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    let realm = try! Realm()
    let results = try! Realm().objects(Category.self)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.choosingButton.titleLabel?.text = variablesForPick[tempNumberOfVariable]
        
        guard let image = self.imageOfProduct else { return }
        self.productImage.isHidden = false
        self.productImage.image = image
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if self.traitCollection.forceTouchCapability == .available
        {
            registerForPreviewing(with: self, sourceView: view)
        }
        else
        {
            print("3D Touch Not Available")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.traitCollection.forceTouchCapability == .available
        {
            registerForPreviewing(with: self, sourceView: view)
        }
        else
        {
            print("3D Touch Not Available")
        }
        
        for _ in 0...self.results.count {
            pickedCategories.append(false)
        }
        
        if self.currentState == .editing {
            self.removeButton.isEnabled = true
            self.removeButton.isHidden = false
            self.initEditing()
        }
        
        if (self.currentState == .editing) {
            if let item = self.editingItem {
                self.productImage.isHidden = false
                self.productImage.image = DataManager.getImage(imageName: item.id.description)
                self.imageOfProduct = DataManager.getImage(imageName: item.id.description)
            }
        }
        
        self.nameTextField.delegate = self
        self.volumeTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        if let item = editingItem {
            self.nameTextField.text = self.editingItem?.name
            self.volumeTextField.text = self.editingItem?.tempVolume.description
            self.navigationBarTitleChanger.title = item.name == "" ? "Редактирование" : item.name
        }
    }
    
    private func initEditing() {
        if let item = self.editingItem {
            self.nameTextField.text = item.name
            self.volumeTextField.text = item.tempVolume.description
            let categs = item.getCategories().split(separator: ";")
            for cat in categs {
                for catName in results {
                    if cat == catName.stringName,
                        let ind = results.index(of: catName) {
                        pickedCategories[ind] = true
                    }
                }
            }
            if (self.editingItem?.isLiquid ?? false) {
                self.tempNumberOfVariable = 0
            } else if (self.editingItem?.isHaveWeight ?? false)
            {
                self.tempNumberOfVariable = 1
            } else if (self.editingItem?.isCountable ?? false)
            {
                self.tempNumberOfVariable = 2
            }
            else {
                self.tempNumberOfVariable = 3
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
    
    func initForEditing(item: ProductItem) {
        self.currentState = .editing
        self.editingItem = item
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        if !(self.volumeTextField.text?.isDouble() ?? false) {
            let alertWarning = UIAlertView(title:"Ошибка", message: "Введены некорректные данные", delegate:nil, cancelButtonTitle:"Продолжить")
            alertWarning.show()
            return
        }
        
        var isLiq = false
        var isHaveW = false
        var isCnt = false
        
        if (0  == tempNumberOfVariable) {
            isLiq = true
        } else if (1  == tempNumberOfVariable)
        {
            isHaveW = true
        } else if (2 == tempNumberOfVariable)
        {
            isCnt = true
        }
        
        var categoriesPicked : [Category] = []
        let cnt = pickedCategories.count
        
        for i in 0...cnt - 1 {
            if (pickedCategories[i]) {
                categoriesPicked.append(results[i])
            }
        }
        
        
        let newProduct = ProductItem()
        
        var vol = 0.0
        if (volumeTextField.text?.isDouble())! {
            vol = Double(volumeTextField.text ?? "0")!
        }
        
        newProduct.setProperties(name: nameTextField.text == ""
            ? "undefined"
            : nameTextField.text
            ?? self.navigationBarTitleChanger.title ?? "undefined",
                                 tempVol: vol,
                                 isLiquid: isLiq,
                                 isHaveW: isHaveW,
                                 isCountable: isCnt,
                                 categories: categoriesPicked,
                                 initVol: (self.editingItem?.initalVolume ?? vol) > vol ?
                                    self.editingItem?.initalVolume
                                    : vol,
                                 id: (editingItem ?? newProduct).hash
        )
        
        
        if let removingItem = self.editingItem {
            let removing = self.realm.objects(ProductItem.self).filter("name = '\(removingItem.name)'")
            try! self.realm.write {
                if removing.count > 0 {
                    DataManager.deleteDirectory(imageName: self.editingItem!.hash.description)
                    self.realm.delete(removing)
                }
            }
        }
        
        try! self.realm.write {
            let duplicate = self.realm.objects(ProductItem.self).filter({ (item : ProductItem) -> Bool in
                if item.name.lowercased() == newProduct.name.lowercased() {
                    return true
                }
                return false
            })
            if duplicate.count == 0 {
                realm.add(newProduct)
            }
            else if duplicate.count >= 1 {
                duplicate.forEach({ (dup) in
                    newProduct.tempVolume += dup.tempVolume
                })
                if newProduct.initalVolume <= newProduct.tempVolume {
                    newProduct.initalVolume = newProduct.tempVolume
                }
                self.realm.delete(duplicate)
                self.realm.add(newProduct)
            }
        }
        
        if let image = self.imageOfProduct {
            DataManager.saveImageToDocumentDirectory(image: image, name: newProduct.id.description)
        }
        
        if (self.parentVC != nil) && currentState == .editingNew {
            if let index = self.editingIndex {
                self.parentVC!.removeItem(index: index)
            }
        }
        
        dismiss(animated: true, completion: nil)
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
    
    @IBAction func removeButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: self.nameTextField.text,
                                      message: "Are you sure remove this product?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: { action in
            switch action.style{
            case .default:
                if let removingItem = self.editingItem {
                    let removing = self.realm.objects(ProductItem.self).filter("name = '\(removingItem.name)'")
                    let name = removingItem.name
                    try! self.realm.write {
                        self.realm.delete(removing)
                    }
                    DataManager.deleteDirectory(imageName: name)
                }
                self.dismiss(animated: true, completion: nil)
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("canceled")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
            }}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addPhotoButtonTapped(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
//        kek.sourceType = .camera
//
//        present(kek, animated: true, completion: nil)
        let alert = UIAlertController(title: self.nameTextField.text,
                                      message: "Where to get image?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            switch action.style{
            case .default:
                if(UIImagePickerController .isSourceTypeAvailable(.camera)){
                    imagePickerController.sourceType = .camera
                    self.present(imagePickerController, animated: true, completion: nil)
                } else {
                    let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera or permissions", delegate:nil, cancelButtonTitle:"OK")
                    alertWarning.show()
                }
                
            case .cancel: break
            case .destructive: break
            }}))
        alert.addAction(UIAlertAction(title: "Library", style: .default, handler: { action in
            switch action.style{
            case .default:
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                
                imagePickerController.allowsEditing = false
                
                self.present(imagePickerController, animated: true)
            case .cancel: break
            case .destructive: break
            }}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
            switch action.style{
            case .default:
                alert.dismiss(animated: true, completion: nil)
            case .cancel: break
            case .destructive: break
            }}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureWithVC(vc: UIViewController, index: Int) {
        if vc is NewItemsEditingViewController {
            self.currentState = .editingNew
            self.parentVC = vc as? NewItemsEditingViewController
            self.editingIndex = index
        }
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

extension AddProductViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[.originalImage] as? UIImage else {
                return
        }
        
        self.imageOfProduct = image
        self.productImage.image = image
        //dismiss(animated:true, completion: nil)
    }
    

}


extension String {
    func isDouble() -> Bool {
        
        if let doubleValue = Double(self) {
            
            if doubleValue >= 0 {
                return true
            }
        }
        
        return false
    }
}

extension AddProductViewController: UIViewControllerPreviewingDelegate
{
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController?
    {
        
        let convertedLocation = view.convert(location, to: self.productImage)
        if self.productImage.bounds.contains(convertedLocation)
        {
            // Init the peek view controller, set relevant properties, and return it
            let otherViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController
            otherViewController?.image = self.productImage.image
            previewingContext.sourceRect = self.productImage.frame
            return otherViewController
        }
        else
        {
            return nil
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController)
    {
        // Present or push the view controller
        present(viewControllerToCommit, animated: true)
    }
}
