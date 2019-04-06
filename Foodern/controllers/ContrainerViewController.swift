//
//  ContrainerViewController.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 22/11/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import UIKit
import QuartzCore
import Realm
import RealmSwift

class ContainerViewController: UIViewController {
    
    enum SlideOutState {
        case bothCollapsed
        case leftPanelExpanded
    }
    
    var foodNavigationController: UINavigationController!
    var foodViewController: FoodTableViewController!
    
    var currentState: SlideOutState = .bothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .bothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    var sideViewController: SidePanelViewController?

    
    let centerPanelExpandedOffset: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodViewController = UIStoryboard.foodViewController()
        foodViewController.delegate = self
        
        foodNavigationController = UINavigationController(rootViewController: foodViewController)
        view.addSubview(foodNavigationController.view)
        addChild(foodNavigationController)
        
        foodNavigationController.didMove(toParent: self)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        
        ContainerViewController.createCategories()
    }
}

// MARK: CenterViewController delegate
extension ContainerViewController: FoodTableViewControllerDelegate {
    
    func toggleLeftPanel() {
        
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func collapseSidePanels() {
        
        switch currentState {
        case .leftPanelExpanded:
            toggleLeftPanel()
        default:
            break
        }
    }
    
    func addLeftPanelViewController() {
        
        guard sideViewController == nil else {
            addChildSidePanelController(sideViewController!)
            return
        }
        
        if let vc = UIStoryboard.sideViewController() {
            vc.items = SideMenuItem.allItems()
            addChildSidePanelController(vc)
            sideViewController = vc
        }
    }
    
    func addChildSidePanelController(_ sidePanelController: SidePanelViewController) {
        
        sidePanelController.delegate = foodViewController
        view.insertSubview(sidePanelController.view, at: 0)
        
        addChild(sidePanelController)
        sidePanelController.didMove(toParent: self)
    }
    
    
    func animateLeftPanel(shouldExpand: Bool) {
        
        if shouldExpand {
            currentState = .leftPanelExpanded
            animateCenterPanelXPosition(targetPosition: foodNavigationController.view.frame.width - centerPanelExpandedOffset)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .bothCollapsed
                self.sideViewController?.view.removeFromSuperview()
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.foodNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if shouldShowShadow {
            foodNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            foodNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
}

// MARK: Gesture recognizer

extension ContainerViewController: UIGestureRecognizerDelegate {
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        
        switch recognizer.state {
            
        case .began:
            if currentState == .bothCollapsed {
                if gestureIsDraggingFromLeftToRight {
                    addLeftPanelViewController()
                }
                showShadowForCenterViewController(true)
            }
            
        case .changed:
            break
            //self.foodViewController.view.endEditing(true)
            
        case .ended:
            if let _ = sideViewController,
                let rview = recognizer.view {
                // animate the side panel open or closed based on whether the view has moved more or less than halfway
                let rviewCenter = rview.center.x
                
                var hasMovedGreaterThanHalfway : Bool = false
                switch currentState {
                case .bothCollapsed: do {
                        hasMovedGreaterThanHalfway = rviewCenter * 2 > view.bounds.size.width
                    }
                default : do {
                        hasMovedGreaterThanHalfway = rviewCenter / 2 > view.bounds.size.width
                    }
                }
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
                
            }
            
        default:
            break
        }
    }
}



private extension UIStoryboard {
    
    static func main() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    static func sideViewController() -> SidePanelViewController? {
        return main().instantiateViewController(withIdentifier: "sideViewController") as? SidePanelViewController
    }
    
    
    static func foodViewController() -> FoodTableViewController? {
        return main().instantiateViewController(withIdentifier: "foodViewController") as? FoodTableViewController
    }
}

private extension ContainerViewController {
    private static func createCategories() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(Category.self))
        }
        
        
        
        if (realm.objects(Category.self).count == 0) {
            let fridge = Category()
            fridge.stringName = "Холодильник"
            let freezer = Category()
            freezer.stringName = "Морозильная камера"
            let liquid = Category()
            liquid.stringName = "Жидкость"
            try! realm.write {
                realm.add(fridge)
                realm.add(freezer)
                realm.add(liquid)
            }
        }
    }
}
