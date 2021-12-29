/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Helpers for loading images and data.
*/

import UIKit
import SwiftUI
import CoreLocation

/// Landmark
fileprivate let landmarkDocumentFolder = "landmark"
fileprivate let landmarkFilename = "landmarkData.json"

var landmarkData: [Landmark] = loadJsonFile(landmarkFilename, landmarkDocumentFolder)

let isLandmarkDataSaved:Bool = CommonUtils.storeJsonToDocumentFile(landmarkData, to: landmarkDocumentFolder, as: landmarkFilename)

let isLandmarkDataFileDeleted:Bool = CommonUtils.removeFileFromDocument(folderName: landmarkDocumentFolder, fileName: landmarkFilename)

func reloadLandmarkData() {
    landmarkData = loadJsonFile(landmarkFilename, landmarkDocumentFolder)
}

/// Signatures
fileprivate let signaturesDocumentFolder = "signatures"
fileprivate let signaturesFilename = "signaturesData.json"

// TDD - testCommonUtilssStoreJsonToDocumentFile() - 1
var signaturesData: [Signature] = loadJsonFile(signaturesFilename, signaturesDocumentFolder)

// call this var when required to save file to document folder
let isSignatuesDataSaved:Bool = CommonUtils.storeJsonToDocumentFile(signaturesData, to: signaturesDocumentFolder, as: signaturesFilename)

// call this var when required to delete file from document folder
let isSignaturesDataFileDeleted:Bool = CommonUtils.removeFileFromDocument(folderName: signaturesDocumentFolder, fileName: signaturesFilename)

func reloadSignaturesDataWithShuffle() {
    signaturesData = loadJsonFile(signaturesFilename, signaturesDocumentFolder)
    signaturesData.shuffle()
}

/// SFSymbol
fileprivate let ssSFSymbolFilename = "SSSFSymbol.txt"

var ssSFSymbolData: [String] = CommonUtils.readTextFileFromBundle(ssSFSymbolFilename)

func symbolArrayFoundFrom(searchQuery query:String) -> [String] {
    //if query.isEmpty {
    //    return ssSFSymbolData
    //}
    let symbolArray = ssSFSymbolData.compactMap {
        $0.lowercased().contains(query.lowercased()) ? $0 : nil
    }
    return symbolArray
}


let timeZoneData: [SSTimeZone] = TimeZone.knownTimeZoneIdentifiers.compactMap{ id->SSTimeZone? in
    let components = id.components(separatedBy: "/")
    guard components.count == 2, let continent = components.first, let city = components.last else {return nil}
    let timeZone = TimeZone(identifier: id)
    let localizedName = timeZone?.localizedName(for: .standard, locale: Locale.current) ?? id
    let abbreviation = timeZone?.abbreviation() ?? "" 
    let secondsFromGMT = timeZone?.secondsFromGMT() ?? 0
    return SSTimeZone(city: city, continent: continent, abbreviation: abbreviation, localizedName: localizedName, secondsFromGMT:secondsFromGMT)
}.sorted { $0.city < $1.city /*&& $0.continent < $1.continent*/ }


// TDD - testCommonUtilssStoreJsonToDocumentFile() - 2
func loadJsonFile<T: Decodable>(_ filename: String, _ folderName: String) -> T {
    // SSNote - to search first in local folder then load from Bundle
    let folderPath = CommonUtils.cuDocumentFolderPath.stringByAppendingPathComponent(path: folderName)
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

