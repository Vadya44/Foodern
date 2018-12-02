//
//  VariablePickerViewController.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 01/12/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import UIKit

class VariablePickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate  {

    @IBOutlet var modePicker: UIPickerView!
    
    @IBOutlet var popUpVIew: UIView!
    
    var delegate : AddProductViewControllerDelegate?
    var currentRow : Int = 0
    
    let variablesForPick = ["гр.", "кг.", "мл.", "л.", "другое"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modePicker.layer.cornerRadius = 5
        modePicker.layer.masksToBounds = true
        modePicker.layer.borderWidth = 1
        modePicker.layer.borderColor = #colorLiteral(red: 0.8039215686, green: 0.9333333333, blue: 0.9725490196, alpha: 1)
        modePicker.clipsToBounds = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(VariablePickerViewController.pickerTapped(tapRecognizer:)))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        popUpVIew.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return variablesForPick.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return variablesForPick[row]
    }
    
    @objc func pickerTapped(tapRecognizer:UITapGestureRecognizer)
    {
        if tapRecognizer.state == .ended {
            let rowHeight = self.modePicker.rowSize(forComponent: 0).height
            let selectedRowFrame = self.modePicker.bounds.insetBy(dx: 0, dy: (self.modePicker.frame.height - rowHeight) / 2)
            let userTappedOnSelectedRow = selectedRowFrame.contains(tapRecognizer.location(in: self.modePicker))
            if userTappedOnSelectedRow {
                self.delegate?.newVariableValue(self.modePicker.selectedRow(inComponent: 0))
                self.dismiss(animated: true, completion: nil)
            }
        }
        if tapRecognizer.state == .ended && self.modePicker.frame.contains(tapRecognizer.location(in: popUpVIew))
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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
