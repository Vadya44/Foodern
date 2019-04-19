//
//  ImageViewController.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 09/04/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if let image = image {
            self.imageView.image = image
        }
    }
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
    }
}
