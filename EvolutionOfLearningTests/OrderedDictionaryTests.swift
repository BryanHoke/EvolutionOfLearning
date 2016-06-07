//
//  OrderedDictionaryTests.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/7/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import XCTest

class OrderedDictionaryTests : XCTestCase {

	func testIteration() {
		let dictionary: OrderedDictionary<String, Int> = ["zero": 0, "one": 1, "two": 2]
		var keyValues = [(String, Int)]()
		for (key, value) in dictionary {
			keyValues.append((key, value))
		}
		
		XCTAssertEqual(keyValues.count, 3)
		
		XCTAssertEqual(keyValues[0].0, "zero")
		XCTAssertEqual(keyValues[0].1, 0)
		
		XCTAssertEqual(keyValues[1].0, "one")
		XCTAssertEqual(keyValues[1].1, 1)
		
		XCTAssertEqual(keyValues[2].0, "two")
		XCTAssertEqual(keyValues[2].1, 2)
	}

}
