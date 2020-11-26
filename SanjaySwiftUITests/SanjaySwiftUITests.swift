//
//  SanjaySwiftUITests.swift
//  SanjaySwiftUITests
//
//  Created by Sanjay Sampat on 20/07/20.
//  Copyright © 2020 Sanjay Sampat. All rights reserved.
//

import XCTest
@testable import SanjaySwiftUIPay

class SanjaySwiftUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    ///CommonUtils.swift, Data.swift
    
    func testCommonUtilsCreateRequiredFolders() throws {
        XCTAssertTrue(CommonUtils.createRequiredFolders(),"createRequiredFolders failed.")
    }

    func testCommonUtilsthumbnailForVideoAtURL() throws {
        let testMp4File = "Example21.mp4"
        guard let file = Bundle.main.url(forResource: testMp4File, withExtension: nil)
            else {
            XCTAssert(false, "Couldn't find \(testMp4File) in main bundle.")
            return
        }
        guard let resultedImage = CommonUtils.thumbnailForVideoAtURL( url: file, maxWidth: CommonUtils.cu_myVideoThumbImageWidth ) else {
            XCTAssert(false, "thumbnailForVideoAtURL could not be created.")
            return
        }
        XCTAssert(resultedImage.size.width <= CGFloat(CommonUtils.cu_myVideoThumbImageWidth), "Width of thumb image is more then max height/width.")
        XCTAssert(resultedImage.size.height <= CGFloat(CommonUtils.cu_myVideoThumbImageWidth), "height of thumb image is more then max height/width.")

    }
    
    func testCommonUtilssStoreJsonToDocumentFile() throws {
        try? testCommonUtilsCreateRequiredFolders()
        let testDocumentFolder = "test"
        let testJsonFilename = "testJsonData.json"
        if FileManager.default.fileExists(atPath: CommonUtils.cuDocumentFolderPath.stringByAppendingPathComponent(path: "\(testDocumentFolder)/\(testJsonFilename)")) {
            // remove old file.
            XCTAssertTrue(CommonUtils.removeFileFromDocument(folderName: testDocumentFolder, fileName: testJsonFilename),"Old JSON file in folder could not be removed.")
        }
        XCTAssertTrue(CommonUtils.storeJsonToDocumentFile(signaturesData, to: testDocumentFolder, as: testJsonFilename),"JSON file could not be saved.")
    }

    func testPerformanceCommonUtilsthumbnailForVideoAtURL() throws {
        self.measure {
            try? testCommonUtilsthumbnailForVideoAtURL()
        }
    }
    
    

}
