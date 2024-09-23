//
//  LocalFileManager.swift
//  CryptoX
//
//  Created by pritam on 2024-09-20.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    // One singleton Instance
    static let instance = LocalFileManager()
    
    private init() {}
    
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
        // create folder
        createdFolderIfNeeded(folderName: folderName)
        
        // get path for image
        guard
            let data = image.pngData() ,
            let url = getURLForImage(imageName: imageName, folderName: folderName)
        else { return }
        
        // save image to path
        do {
            try data.write(to:  url)
        } catch let error {
            print("Error saving image. ImageName: \(imageName) \(error)")
        }
    }
    
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path(percentEncoded: false)) else {
            return nil
        }
        
        
        // loads the image that in the given URL path 
        return UIImage(contentsOfFile: url.path(percentEncoded: false))
              
    }
    
    // Create the Folder
    private func createdFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else {return}
        if !FileManager.default.fileExists(atPath: url.path(percentEncoded: false)) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error unable to create directory. FolderName: \(folderName). \(error)")
            }
        }
    }
    
    // Get the folder
    private func getURLForFolder(folderName: String) -> URL? {
        
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else { return nil }
        return url.appending(path: folderName)
    }
    
    // get the URL for provided image
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else { return nil }
        return folderURL.appending(path: imageName + ".png")
    }
    
}
