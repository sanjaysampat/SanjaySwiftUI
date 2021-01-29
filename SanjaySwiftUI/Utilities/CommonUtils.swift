//
//  CommonUtils.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 08/08/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import Foundation
import AVFoundation
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
    
    static let cu_NotificationDataAlertKey = "SSNotificationData"
    static let cu_ResetEmitterNotification = "SSresetEmitterNotification"
    
    static let cu_myVideoThumbImageWidth = 150
    static let cu_VideoFileNameDateFormat = "yyyyMMddHHmmss"

    
    // vars
    static var cu_APPVersionNumber              = "0.0"
    static var cuDeviceTokenId                  = ""

    //network Reachability Variable
    static var cuIsReachabilityThere            = true

    static var cuDocumentFolderPath             = ""
    static var cuApplicationSupportFolder       = ""
    static var cuScreenRecordFolder             = ""
    
    static func trialWork() {
        
    }
    
    // Tests in TrialWorksTests.swift
    //let intArray2 = [2,500, 2,10,20,30,40,500, 100,100,100,200,200,500,500, -40,-30,-20,-10,0,10,20,30,40,500, -9,-8,-7,-6,-5,-4,-3,-2,-1,0, ]
    // eg. 2,500 is first sequence. Next sequence starts as 2 is smaller then 500.
    static func getHighestTotalOfNumericSequence<T:Numeric & Comparable>( tArray:[T] ) -> T? {
        var total:T? = nil
        var lastElement:T? = nil
        var maxTotal:T? = nil
        
        tArray.map { element in
            //print(element)
            if let lastUsedElement = lastElement {
                if element >= lastUsedElement {
                    total = (total ?? 0) + element
                    //print("total=\(total ?? 0)")
                } else {
                    if let maxUsedTotal = maxTotal {
                        if let totalUsed = total {
                            maxTotal = max( maxUsedTotal, totalUsed )
                            //print("Next maxTotal=\(maxTotal ?? 0)")
                        }
                    } else {
                        maxTotal = total
                        //print("First maxTotal=\(maxTotal ?? 0)")
                    }
                    total = element
                }
            } else {
                total = element
                //print("First total=\(total ?? 0)")
            }
            lastElement = element
            
        }
        if let maxUsedTotal = maxTotal {
            if let totalUsed = total {
                maxTotal = max( maxUsedTotal, totalUsed )
            }
        } else {
            maxTotal = total
        }
        //print("Last maxTotal=\(maxTotal ?? 0)")
        return maxTotal
    }
    
    // TDD - testCommonUtilsCreateRequiredFolders()
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
        
        // Screen record folder
        CommonUtils.cuScreenRecordFolder = CommonUtils.cuDocumentFolderPath.stringByAppendingPathComponent(path: "ScreenRecord")
        print(CommonUtils.cuScreenRecordFolder)
        // /Users/sanjaysampat/Library/Developer/CoreSimulator/Devices/8A6FB310-2A14-4D03-A307-28B0706B1C52/data/Containers/Data/Application/821F54CD-8E06-4FCA-9A27-EFE37F6B6B70/Documents/ScreenRecord
        if !fileManager.fileExists(atPath: CommonUtils.cuScreenRecordFolder) {
            do {
                try fileManager .createDirectory(atPath: CommonUtils.cuScreenRecordFolder, withIntermediateDirectories: false, attributes: nil)
            } catch _ as NSError {
                return false
            }
        }


        return true
    }
    
    // TDD - testCommonUtilssStoreJsonToDocumentFile() - 3
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
    
    // TDD - testCommonUtilssStoreJsonToDocumentFile() - 4
    static func writeFileToDocument(folderName:String, fileName:String, fileData:Data, atomicWrite:Bool = true) -> Bool {
        return writeFile(basePath:CommonUtils.cuDocumentFolderPath, folderName:folderName, fileName:fileName, fileData:fileData, atomicWrite:atomicWrite)
    }
    
    static func writeFileToSupportFolder(folderName:String, fileName:String, fileData:Data, atomicWrite:Bool = true) -> Bool {
        return writeFile(basePath:CommonUtils.cuApplicationSupportFolder, folderName:folderName, fileName:fileName, fileData:fileData, atomicWrite:atomicWrite)
    }

    // TDD - testCommonUtilssStoreJsonToDocumentFile() - 5
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
    
    // TDD - testCommonUtilssStoreJsonToDocumentFile() - 6
    static func removeFileFromDocument(folderName:String, fileName:String) -> Bool {
        return removeFile(basePath:CommonUtils.cuDocumentFolderPath, folderName:folderName, fileName:fileName)
    }
    
    static func removeFileFromSupportFolder(folderName:String, fileName:String) -> Bool {
        return removeFile(basePath:CommonUtils.cuApplicationSupportFolder, folderName:folderName, fileName:fileName)
    }

    // TDD - testCommonUtilssStoreJsonToDocumentFile() - 7
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
    
    // MARK: - Image Methods
    // TDD - testCommonUtilsthumbnailForVideoAtURL() && testPerformanceCommonUtilsthumbnailForVideoAtURL()
    static func thumbnailForVideoAtURL(url: URL, maxWidth: Int = 0) -> UIImage? {
        var returnImageOptional:UIImage? // = UIImage(named: "delete_selection_gray")  // default image if required.
        let asset = AVAsset(url: url)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            returnImageOptional = UIImage.init(cgImage: imageRef)
            returnImageOptional = returnImageOptional?.normalizedImage()
            //return UIImage.init(cgImage: imageRef, scale: 1.0 , orientation: UIImageOrientation.Right)
        } catch {
            print("error")
        }
        if ( maxWidth > 0 ) {
            let resultCGSize = CGSize(width: maxWidth, height: maxWidth)
            returnImageOptional = returnImageOptional?.RBResizeImage(targetSize: resultCGSize)
        }
        return returnImageOptional
    }

    // MARK: - Methods used in function showAlert(alert: UIAlertController)
    static func topMostViewController() -> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }

    static func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
        .filter {$0.activationState == .foregroundActive}
        .compactMap {$0 as? UIWindowScene}
        .first?.windows.filter {$0.isKeyWindow}.first
    }
    
    static func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }

}
