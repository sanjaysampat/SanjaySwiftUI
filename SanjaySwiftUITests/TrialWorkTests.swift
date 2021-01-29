//
//  TrialWorkTests.swift
//  SanjaySwiftUITests
//
//  Created by Sanjay Sampat on 29/01/21.
//  Copyright © 2021 Sanjay Sampat. All rights reserved.
//

import XCTest
@testable import SanjaySwiftUIPay

class TrialWorkTests: XCTestCase {

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
    
    func test_CommonUtils_getHighestTotalOfNumericSequenceForInt() throws {

        let intArray0:[Int] = []
        XCTAssertNil( CommonUtils.getHighestTotalOfNumericSequence(tArray: intArray0), "nil should be returned" )

        let intArray1 = [2,500, 0,10,20,30,40,500, 100,500, -40,-30,-20,-10,0,10,20,30,40,500, -9,-8,-7,-6,-5,-4,-3,-2,-1,0, ]
        XCTAssert(CommonUtils.getHighestTotalOfNumericSequence(tArray: intArray1) == 600, "Normal test failed")

        let intArray2 = [2,500, 0,10,20,30,40,500, 100,100,100,200,200,500,500, -40,-30,-20,-10,0,10,20,30,40,500, -9,-8,-7,-6,-5,-4,-3,-2,-1,0, ]
        XCTAssert(CommonUtils.getHighestTotalOfNumericSequence(tArray: intArray2) == 1700, "test with same elements in sequence failed")

        let intArray3 = [-9,-8,-7,-6,-5,-4,-3,-2,-1, ]
        XCTAssert(CommonUtils.getHighestTotalOfNumericSequence(tArray: intArray3) == -45, "Error of only single sequence")

        let intArray4 = [-9,-8,-7,-6,-5,-4,-3,-2,-1, -30,-15,-5, ]
        XCTAssert(CommonUtils.getHighestTotalOfNumericSequence(tArray: intArray4) == -45, "Error of negetive sequences 1")

        let intArray5 = [-30,-15,-5, -9,-8,-7,-6,-5,-4,-3,-2,-1, ]
        XCTAssert(CommonUtils.getHighestTotalOfNumericSequence(tArray: intArray5) == -45, "Error of negetive sequences 2")

        let intArray6 = [0,0,0, -9,-8,-7,-6,-5,-4,-3,-2,-1,0,0,0, ]
        XCTAssert(CommonUtils.getHighestTotalOfNumericSequence(tArray: intArray6) == 0, "Error of negetive and 0's sequences")

        let intArray7 = [-10]
        XCTAssert(CommonUtils.getHighestTotalOfNumericSequence(tArray: intArray7) == -10, "Error of single element")

    }
    
    func test_CommonUtils_getHighestTotalOfNumericSequenceForDouble() throws {

        let doubleArray0:[Double] = []
        XCTAssertNil( CommonUtils.getHighestTotalOfNumericSequence(tArray: doubleArray0), "nil should be returned" )
        
        let doubleArray1:[Double] = [2.5,500.5, 0,10.01,20.02,30.03,40.04,500.05, 100.1111,500.5555, 200.2222,400.4444, -40,-30,-20,-10,0,10,20,30,40,500, -9,-8,-7,-6,-5,-4,-3,-2,-1,0, ]
        XCTAssert(CommonUtils.getHighestTotalOfNumericSequence(tArray: doubleArray1) == 600.6666, "Normal test failed")
        
        let doubleArray2 = [2.5,500.5, 0,10.01,20.02,30.03,40.04,500.05, 100.1,100.1,200.2,200.2,400.4,500.5,500.5, -40,-30,-20,-10,0,10,20,30,40,500, -9,-8,-7,-6,-5,-4,-3,-2,-1,0, ]
        XCTAssert(CommonUtils.getHighestTotalOfNumericSequence(tArray: doubleArray2) == 2002, "test with same elements in sequence failed")
        
        let doubleArray3 = [-9.09,-8.08,-7.07,-6.06,-5,-4.04,-3,-2,-1.01, ]
        // SSNote: Answer is -45.349999999999994 // so use 'range' and 'news' operators instead
        XCTAssert( (-45.35)...(-45.34) ~= CommonUtils.getHighestTotalOfNumericSequence(tArray: doubleArray3) ?? 0.00, "Error of only single sequence of few int elements in double array.")
        
        let doubleArray4 = [-9.09,-8.08,-7.07,-6.06,-5,-4.04,-3,-2,-1.01, -30,-15,-5, ]
        XCTAssert( (-45.35)...(-45.34) ~= CommonUtils.getHighestTotalOfNumericSequence(tArray: doubleArray4) ?? 0.00, "Error of negetive sequences 1")
        
        let doubleArray5 = [-30,-15,-5, -9.09,-8.08,-7.07,-6.06,-5,-4.04,-3,-2,-1.01, ]
        XCTAssert( (-45.35)...(-45.34) ~= CommonUtils.getHighestTotalOfNumericSequence(tArray: doubleArray5) ?? 0.00, "Error of negetive sequences 2")
        
        let doubleArray6 = [0.0,0.00,0.000, -9.09,-8.08,-7.07,-6.06,-5,-4.04,-3,-2,-1.01, ]
        XCTAssert(CommonUtils.getHighestTotalOfNumericSequence(tArray: doubleArray6) == 0, "Error of negetive and 0's sequences")
        
        let doubleArray7 = [-9.0123456789]
        XCTAssert(CommonUtils.getHighestTotalOfNumericSequence(tArray: doubleArray7) == -9.0123456789, "Error of single element")
        
    }

}
