/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Helpers for loading images and data.
*/

import UIKit
import SwiftUI
import CoreLocation

fileprivate let landmarkDocumentFolder = "landmark"
fileprivate let landmarkFilename = "landmarkData.json"

var landmarkData: [Landmark] = load(landmarkFilename)

let isLandmarkDataSaved:Bool = CommonUtils.storeJsonToDocumentFile(landmarkData, to: landmarkDocumentFolder, as: landmarkFilename)

let isLandmarkDataFileDeleted:Bool = CommonUtils.removeFileFromDocument(folderName: landmarkDocumentFolder, fileName: landmarkFilename)

func load<T: Decodable>(_ filename: String) -> T {
    // SSNote - to search first in local folder then load from Bundle
    let folderPath = CommonUtils.cuDocumentFolderPath.stringByAppendingPathComponent(path: landmarkDocumentFolder)
    let documentURL = URL(fileURLWithPath: folderPath.stringByAppendingPathComponent(path: filename))
    do {
        let data:Data = try Data(contentsOf: documentURL)
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        let data: Data
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
        
    }
}

final class ImageStore {
    typealias _ImageDictionary = [String: CGImage]
    fileprivate var images: _ImageDictionary = [:]

    fileprivate static var scale = 2
    
    static var shared = ImageStore()
    
    func image(name: String) -> Image {
        let index = _guaranteeImage(name: name)
        
        return Image(images.values[index], scale: CGFloat(ImageStore.scale), label: Text(name))
    }

    static func loadImage(name: String) -> CGImage {
        guard
            let url = Bundle.main.url(forResource: name, withExtension: "jpg"),
            let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
            let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            fatalError("Couldn't load image \(name).jpg from main bundle.")
        }
        return image
    }
    
    fileprivate func _guaranteeImage(name: String) -> _ImageDictionary.Index {
        if let index = images.index(forKey: name) { return index }
        
        images[name] = ImageStore.loadImage(name: name)
        return images.index(forKey: name)!
    }
}

