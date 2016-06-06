//
//  GeneMapTests.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/10/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import XCTest

class GeneMapTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
	}
	
	func testGeneMap() {
		let inputs: [[Double]] = [[1, 1], [0, 1], [1, 0], [0, 0]]
		
		let patterns1 = Pattern.patternsWithInputVectors(inputs, targets: [1, 0, 1, 0])
		let task1 = Task(id: 1, patterns: patterns1)
		
		let patterns2 = Pattern.patternsWithInputVectors(inputs, targets: [1, 1, 0, 0])
		let task2 = Task(id: 2, patterns: patterns2)
		
		var geneMap = GeneMap(bitsPerWeight: 4, offset: 8)
		geneMap.addMapping(for: task1)
		geneMap.addMapping(for: task2)
		
		let range1 = geneMap.geneRange(of: task1)
		XCTAssert(range1 == 8..<20, "Incorrect geneRange for task1: \(range1)")
		
		let range2 = geneMap.geneRange(of: task2)
		XCTAssert(range2 == 20..<32, "Incorrect geneRange for task2: \(range2)")
		
		let size = geneMap.chromosomeSize
		XCTAssert(size == 32, "Incorrect chromosomeSize: \(size)")
	}

}
