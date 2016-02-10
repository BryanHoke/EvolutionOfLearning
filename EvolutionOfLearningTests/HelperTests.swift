//
//  HelperTests.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 2/9/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import XCTest

class HelperTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
	
	func testEncodedIntForBits() {
		XCTAssertEqual(encodedIntFor([false, false, false]), 0)
		XCTAssertEqual(encodedIntFor([true, false, true, true]), 11)
	}

}
