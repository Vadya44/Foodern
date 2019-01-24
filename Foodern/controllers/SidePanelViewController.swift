//
//  SidePanelViewController.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 22/11/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import UIKit

class SidePanelViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: SidePanelViewControllerDelegate?
    
    var items: Array<SideMenuItem>!
    
    var selectedRow = 0
    
    func setRow(row : Int) {
        self.selectedRow = row
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let emptyUIView = UIView()
        //emptyUIView.backgroundColor = UIColor(red: 69, green: 121, blue: 156, alpha: 1.0)
        self.tableView.tableFooterView = emptyUIView
        
        tableView.reloadData()
    }
    
}

// MARK: Table View Data Source
extension SidePanelViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideItemCell", for: indexPath) as! SideItemCell
        cell.configureItem(items[indexPath.row])
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(rgb: 0x3F6E8E)
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let indexPath = IndexPath(row: selectedRow, section: 0)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
}

// Mark: Table View Delegate
extension SidePanelViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 6 {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QRCodeScannerViewController") as? QRCodeScannerViewController
            {
                present(vc, animated: true, completion: nil)
            }
            
        }
        
        let item = items[indexPath.row]
        
        self.setRow(row: indexPath.row)
        
        delegate?.didSelectItem(item)
    }
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
