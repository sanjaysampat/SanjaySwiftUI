//
//  CommonUtils.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 08/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import Foundation
import SwiftUI

// Global functions

// This set up it can act as a placeholder to make your code compile when you’re part-way through your work and don’t want to fill in all the various parts just yet. The magic of gUndefined() is that it will crash as soon as it’s touched – it will work only at compile time (HackingWithSwift - https://www.hackingwithswift.com/)
// eg. usage
// 1) let name: String = gUndefined("Example string")
// 2) func userID(for username: String) -> Int? {
//      gUndefined(username)
//    }
// 3) let timer = Timer(timeInterval: gUndefined(), target: gUndefined(), selector: gUndefined(), userInfo: gUndefined(), repeats: gUndefined())
func gUndefined<T>(_ message: String = "") -> T {
    fatalError("gUndefined: \(message)")
}

// Using memoization to speed up slow functions (HackingWithSwift - https://www.hackingwithswift.com/plus/high-performance-apps/using-memoization-to-speed-up-slow-functions)
func gMemoize<Input: Hashable, Output>(_ function: @escaping (Input) -> Output) -> (Input) -> Output {
    // our item cache
    var storage = [ Input: Output]()

    // send back a new closure that does our calculation
    return { input in
        if let cached = storage[input] {
            return cached
        }

        let result = function(input)
        storage[input] = result
        return result
    }
}
// Recursive memoization
func gRecursiveMemoize<Input: Hashable, Output>(_ function: @escaping ((Input) -> Output, Input) -> Output) -> (Input) -> Output {
    // our item cache
    var storage = [Input: Output]()

    var memo: ((Input) -> Output)!
    memo = { input in
        if let cached = storage[input] {
            return cached
        }

        let result = function(memo, input)
        storage[input] = result
        return result
    }
    return memo
}


struct CommonUtils {

    static let cu_AppBundleId = "com.sanjay.SanjaySwiftUI"

    static let cu_activity_light_theam_color :Color = Color(.sRGB, red: 255/255, green: 236/255, blue: 240/255, opacity: 255/255)
    static let cu_activity_foreground_color :Color = Color(.sRGB, red: 236/255, green: 63/255, blue: 70/255, opacity: 255/255) // Color.pink
    static let cu_activity_background_color :Color = Color.white
    static let cu_activity_light_text_color :Color = Color(.sRGB, red: 242/255, green: 125/255, blue: 131/255, opacity: 255/255)

    static let cu_CornerRadius:CGFloat = 5
    
    static let cu_ResetEmitterNotification = "SSresetEmitterNotification"
    
    // vars
    static var cu_APPVersionNumber              = "0.0"

    static var cuDocumentFolderPath             = ""
    static var cuApplicationSupportFolder       = ""
    
    
    static func createRequiredFolders() -> Bool {
        
        let fileManager:FileManager = FileManager.default

        // Documents folder
        let dirsList = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        if dirsList.count > 0 {
            CommonUtils.cuDocumentFolderPath = dirsList[0]
        }
        if CommonUtils.cuDocumentFolderPath .isEmpty {
            return false
        }
        
        // Support folder // Library/Application Support
        CommonUtils.cuApplicationSupportFolder = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory,.userDomainMask, true).last!
        if !fileManager.fileExists(atPath: CommonUtils.cuApplicationSupportFolder) {
            do {
                try fileManager .createDirectory(atPath: CommonUtils.cuApplicationSupportFolder, withIntermediateDirectories: false, attributes: nil)
            } catch _ as NSError {
                return false
            }
        }
        // Example to create files in Support folder
        //let data:Data = Data()
        //let isSaved = CommonUtils.writeFileToSupportFolder(folderName:"FolderName", fileName:"MyFile.test", fileData:data, atomicWrite:true)
        

        return true
    }
    
    // eg. to use - storeJsonToDocumentFile(signin, to: "Users/\(userEmail)", as: "signin.json")
    static func storeJsonToDocumentFile<T: Encodable>(_ object: T, to folderName:String, as fileName: String) -> Bool {
        var isSuccess = false
        let encoder = JSONEncoder()
        do {
            let fileData = try encoder.encode(object)
            isSuccess = CommonUtils.writeFileToDocument(folderName:folderName, fileName:fileName, fileData:fileData, atomicWrite:true)
        } catch {
            print(error.localizedDescription)
        }
        return isSuccess
    }
    
    static func writeFileToDocument(folderName:String, fileName:String, fileData:Data, atomicWrite:Bool = true) -> Bool {
        return writeFile(basePath:CommonUtils.cuDocumentFolderPath, folderName:folderName, fileName:fileName, fileData:fileData, atomicWrite:atomicWrite)
    }
    
    static func writeFileToSupportFolder(folderName:String, fileName:String, fileData:Data, atomicWrite:Bool = true) -> Bool {
        return writeFile(basePath:CommonUtils.cuApplicationSupportFolder, folderName:folderName, fileName:fileName, fileData:fileData, atomicWrite:atomicWrite)
    }

    static func writeFile(basePath:String, folderName:String, fileName:String, fileData:Data, atomicWrite:Bool = true) -> Bool {
        let fileManager:FileManager = FileManager.default
        do
        {
            // Create subdirectory in support folder
            let folderPath = basePath.stringByAppendingPathComponent(path: folderName)
            try fileManager.createDirectory(atPath: folderPath, withIntermediateDirectories: true, attributes: nil)
            // Save 'data' to file in above directory
            let documentURL = URL(fileURLWithPath: folderPath.stringByAppendingPathComponent(path: fileName))
            if atomicWrite {
                // write data to an auxiliary file first and then exchange the files.
                try fileData.write(to: documentURL, options: [.atomic])
            } else {
                try fileData.write(to: documentURL, options: [.atomic])
            }
            return true
        }
        catch
        {
          print("An error occured \(error)")
        }
        return false
    }
    
    static func readFileFromDocument(folderName:String, fileName:String) -> Data? {
        return readFile(basePath:CommonUtils.cuDocumentFolderPath, folderName:folderName, fileName:fileName)
    }
    
    static func readFileFromSupportFolder(folderName:String, fileName:String) -> Data? {
        return readFile(basePath:CommonUtils.cuApplicationSupportFolder, folderName:folderName, fileName:fileName)
    }

    static func readFile( basePath:String, folderName:String, fileName:String ) -> Data? {
        var fileData:Data? = nil
        do
        {
            let folderPath = basePath.stringByAppendingPathComponent(path: folderName)
            let documentURL = URL(fileURLWithPath: folderPath.stringByAppendingPathComponent(path: fileName))
            
            let data = try Data(contentsOf: documentURL)
            
            fileData = data

        }
        catch
        {
          print("An error occured \(error)")
        }
        
        return fileData
    }
    
    static func removeFileFromDocument(folderName:String, fileName:String) -> Bool {
        return removeFile(basePath:CommonUtils.cuDocumentFolderPath, folderName:folderName, fileName:fileName)
    }
    
    static func removeFileFromSupportFolder(folderName:String, fileName:String) -> Bool {
        return removeFile(basePath:CommonUtils.cuApplicationSupportFolder, folderName:folderName, fileName:fileName)
    }

    static func removeFile( basePath:String, folderName:String, fileName:String ) -> Bool {
        do
        {
            let folderPath = basePath.stringByAppendingPathComponent(path: folderName)
            let documentURL = URL(fileURLWithPath: folderPath.stringByAppendingPathComponent(path: fileName))
            try FileManager.default.removeItem(at: documentURL)
            return true
        }
        catch
        {
            print("An error occured \(error)")
        }
        return false
    }

}
