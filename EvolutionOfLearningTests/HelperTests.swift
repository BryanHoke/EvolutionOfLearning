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
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
	
	func testEncodedIntForBits() {
		XCTAssertEqual(encodedInt(from: [false, false, false]), 0)
		XCTAssertEqual(encodedInt(from: [true, false, true, true]), 11)
	}
	
	func testSignedExponentialEncoding() {
		let encoding11 = signedExponentialEncoding(exponentOffset: -11)
		let encoding10 = signedExponentialEncoding(exponentOffset: -10)
		
		var bits: [Bool] = [1, 1, 1, 1, 1]
		var value = encoding11(bits)
		XCTAssertEqual(value, 16)
		
		value = encoding10(bits)
		XCTAssertEqual(value, 32)
		
		bits[0] = 0
		value = encoding11(bits)
		XCTAssertEqual(value, -16)
		
		bits = [1, 0, 0, 0, 1]
		value = encoding11(bits)
		XCTAssertEqual(value, 0.0009765625)
		
		bits = [1, 0, 0, 0, 0]
		value = encoding11(bits)
		XCTAssertEqual(value, 0)
	}
	
	func testDecodeWeights() {
		let bits: [Bool] = [1, 1, 1, 0, 0, 1, 1, 1, 0]
		let bitsPerWeight = 3
		let layerSize = 3
		let encoding = signedExponentialEncoding(exponentOffset: -1)
		
		let weights = decodeWeights(from: bits, bitsPerWeight: bitsPerWeight, layerSize: layerSize, encoding: encoding)
		XCTAssertEqual(weights, [4, -1, 2])
	}

}
