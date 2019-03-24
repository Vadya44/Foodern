//
//  QRCodeScannerViewController.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 26/11/2018.
//  Copyright © 2018 Вадим Гатауллин. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import RealmSwift
import Realm

enum QRState {
    case editing
    case outVC
}

class QRCodeScannerViewController : UIViewController {
    
    @IBOutlet var messageLabel:UILabel!
    @IBOutlet var topbar: UIView!

    var state: QRState = .editing
    
    var vSpiner: UIView?
    
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.captureSession.startRunning()
        if state == .editing {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        
        // Get the back-facing camera for capturing videos
        var deviceDiscoverySession: AVCaptureDevice.DiscoverySession
        
        if AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back) != nil {
            
            deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
            
        } else {
            
            deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        }
        
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
        view.bringSubviewToFront(messageLabel)
        view.bringSubviewToFront(topbar)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper methods
    
    func launchApp(decodedURL: String) {
        
        if presentedViewController != nil {
            return
        }
        
        let alertPrompt = UIAlertController(title: "Open App", message: "You're going to open \(decodedURL)", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            
            if let url = URL(string: decodedURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension QRCodeScannerViewController : AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                captureSession.stopRunning()
                
                self.showSpinner(onView: self.view)
                self.postRequest(data: metadataObj.stringValue!)
                self.state = .editing
                //self.presentTableView()
                
                messageLabel.text = metadataObj.stringValue
            }
        }
    }
    func presentTableView() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "NewItemsEditingViewController") as! NewItemsEditingViewController
        
        var kek: [ProductItem] = []
        
        let kek12 = ProductItem()
        let kek11 = ProductItem()
        let kek13 = ProductItem()
        kek12.setProperties(name: "kek11", tempVol: nil, fullVolume: nil, isLiquid: nil, isHaveW: nil, tempCapacity: nil, isCountable: nil, tempC: nil, fullC: nil, categories: nil)
        kek13.setProperties(name: "kek12", tempVol: nil, fullVolume: nil, isLiquid: nil, isHaveW: nil, tempCapacity: nil, isCountable: nil, tempC: nil, fullC: nil, categories: nil)
        kek11.setProperties(name: "kek13", tempVol: nil, fullVolume: nil, isLiquid: nil, isHaveW: nil, tempCapacity: nil, isCountable: nil, tempC: nil, fullC: nil, categories: nil)
        
        kek.append(kek12)
        kek.append(kek11)
        kek.append(kek13)
        
        newViewController.dataSource = kek
        self.removeSpinner()
        
        self.present(newViewController, animated: true, completion: nil)
    }
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        self.vSpiner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            self.vSpiner?.removeFromSuperview()
            self.vSpiner = nil
        }
    }
    
    func postRequest(data: String) {
        let url = "https://get-ofz-json-from-qr.enzolab.ru/"
        
        let headers = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let parameters = [
            "qr": data
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default,
                          headers: headers).responseString { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    var items: [ProductItem] = []
                    let regex = try! NSRegularExpression(pattern: "class=\"fsz-13\" id=\"myTextArea\">.*textarea")
                    let regexRes = regex.firstMatch(in: value,
                                                    options: [],
                                                    range: NSRange(location: 0, length: value.utf16.count))
                    var res = String(value[Range(regexRes!.range, in: value)!])
                    res.removeFirst(31)
                    res.removeLast(10)
                    if let data = res.data(using: .utf8) {
                        do {
                            let serialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            if let products = serialized!["document"] as? NSDictionary{
                                if let kek = products["receipt"] as? NSDictionary {
                                    if let products = kek["items"] as? NSArray {
                                        for prod in products {
                                            let tempProduct = prod as! NSDictionary
                                            let strName = tempProduct["name"] as! String
                                            let strQuanity = tempProduct["quantity"] as! Int64
                                            let nameStr = String(utf8String: strName.cString(using: .utf8)!)
                                            let newProduct = ProductItem()
                                            newProduct.setProperties(name: nameStr!, tempVol: Double(strQuanity), fullVolume: Double(strQuanity), isLiquid: false, isHaveW: false, tempCapacity: Double(strQuanity), isCountable: false, tempC: Int(strQuanity), fullC: Int(strQuanity), categories: nil)
                                            items.append(newProduct)
                                        }
                                    }
                                }
                            }
                        } catch {
                            let alert = UIAlertController(title: "Failed",
                                                          message: "Data not found. Maybe check is old",
                                                          preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    self.dismiss(animated: true, completion: nil)
                                case .cancel:
                                    self.dismiss(animated: true, completion: nil)
                                    
                                case .destructive:
                                    self.dismiss(animated: true, completion: nil)
                                }}))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "NewItemsEditingViewController") as! NewItemsEditingViewController
                    newViewController.dataSource = items
                    
                    self.state = .outVC
                    self.removeSpinner()
                    
                    self.present(newViewController, animated: true, completion: nil)
                }
            case .failure(let error):
                print(error)
                let alert = UIAlertController(title: "Failed",
                                              message: "Data not found. Maybe check is old",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        self.dismiss(animated: true, completion: nil)
                    case .cancel:
                        self.dismiss(animated: true, completion: nil)
                        
                    case .destructive:
                        self.dismiss(animated: true, completion: nil)
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
