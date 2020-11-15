//
//  RecordedStore.swift
//  SanjaySwiftUI
//
//  Created by Sanjay Sampat on 06/11/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import SwiftUI
import Combine

class RecordedStore: ObservableObject {
    var recordedFiles: [Recorded] = [] {
        willSet { objectWillChange.send() }
    }
    
    init() {
        recordedFiles = fillRecordedFilesList()
    }
    
    func reloadFileList() {
        recordedFiles = fillRecordedFilesList()
    }
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    func deleteRecording( at offsets: IndexSet ) {
        for (n, iset) in offsets.enumerated() {
            print("SSTODO \(n): '\(iset)'")
            let recorded = recordedFiles[iset]
            if !recorded.fileName.isEmpty {
                do
                {
                    let recordedURL = URL(fileURLWithPath: CommonUtils.cuScreenRecordFolder.stringByAppendingPathComponent(path: recorded.fileName))
                    try FileManager.default.removeItem(at: recordedURL)
                    recordedFiles.remove(atOffsets: offsets)
                    let recordedJpgURL = URL(fileURLWithPath: CommonUtils.cuScreenRecordFolder.stringByAppendingPathComponent(path: recorded.imageName))
                    try FileManager.default.removeItem(at: recordedJpgURL)
                }
                catch
                {
                    print("An error occured \(error)")
                }
            }
        }
    }
    
}

fileprivate func fillRecordedFilesList() -> [Recorded] {
    var recordedArray:[Recorded] = []
    let fileManager:FileManager = FileManager.default
    let fileListOptional = (try? fileManager.contentsOfDirectory(atPath: CommonUtils.cuScreenRecordFolder))
    if let fileList = fileListOptional {
        let fileNameFormatter = DateFormatter()
        fileNameFormatter.dateFormat = CommonUtils.cu_VideoFileNameDateFormat
        let displayDateFormatter = DateFormatter()
        displayDateFormatter.dateFormat = "dd-MMM-yyyy HH:mm:ss"
        let sortedFileList = fileList.sorted().reversed()
        for fileName in sortedFileList {
            if fileName.hasSuffix(".mp4") {
            var name = ""
            if let fileDate = fileNameFormatter.date(from: String(fileName.prefix(14))) {
                name = displayDateFormatter.string(from: fileDate)
            }
                let imageName = "\(String(fileName.prefix(14))).jpg"
                if let _ = UIImage(contentsOfFile: CommonUtils.cuScreenRecordFolder.stringByAppendingPathComponent(path: imageName)) {
                    
                } else {
                    createThumbOfLocalVideo( theFileBasepath:CommonUtils.cuScreenRecordFolder, thevideoFileName: fileName, theImageName:imageName )
                }
                recordedArray.append( Recorded(name: name, fileName: fileName, imageName: "\(imageName)"))
            }
        }
    }

    return recordedArray
}

func createThumbOfLocalVideo( theFileBasepath:String, thevideoFileName: String, theImageName:String ) {
    if let resultedImage = CommonUtils.thumbnailForVideoAtURL( url: URL(fileURLWithPath: theFileBasepath.stringByAppendingPathComponent(path: thevideoFileName)), maxWidth: CommonUtils.cu_myVideoThumbImageWidth ) {
        if let imageData = resultedImage.jpeg {
            let fileURL = NSURL(fileURLWithPath: theFileBasepath.stringByAppendingPathComponent(path: theImageName))
            do {
                try imageData.write(to: fileURL as URL, options: .atomic)
            } catch {
                print(error)
            }
        }
    }
}

struct Recorded: Identifiable {
    var id = UUID()
    var name: String
    var fileName: String
    var imageName: String
    
}
