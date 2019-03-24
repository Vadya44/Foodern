//
//  DataManager.swift
//  Foodern
//
//  Created by Вадим Гатауллин on 23/03/2019.
//  Copyright © 2019 Вадим Гатауллин. All rights reserved.
//

import Foundation
import UIKit


class DataManager {
    init() {
        DataManager.createDirectory()
    }
    static func createDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("images")
        if !fileManager.fileExists(atPath: paths){
            do {
                try fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Couldn't create document directory")
            }
        }else{
            print("Already directory created.")
        }
    }
    
    static func saveImageToDocumentDirectory(image: UIImage, name : String) {
        
        DataManager.deleteDirectory(imageName: name)
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("image\(name)")
        let imageData = image.jpegData(compressionQuality: 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    static func getImage(imageName : String)-> UIImage {
        let fileManager = FileManager.default
        let imagePath = (DataManager.getDirectoryPath() as NSString).appendingPathComponent("image\(imageName)")
        if fileManager.fileExists(atPath: imagePath) {
            return UIImage(contentsOfFile: imagePath)!
        }else{
            print("No Image available")
            return UIImage.init(named: "placeholder")! // Return placeholder image here
        }
    }
    
    static func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func deleteDirectory(imageName: String){
        let fileManager = FileManager.default
        let imagePath = (DataManager.getDirectoryPath() as NSString).appendingPathComponent("image\(imageName)")
        if fileManager.fileExists(atPath: imagePath){
            try! fileManager.removeItem(atPath: imagePath)
        }else{
            print("Directory not found")
        }
    }
    
}
