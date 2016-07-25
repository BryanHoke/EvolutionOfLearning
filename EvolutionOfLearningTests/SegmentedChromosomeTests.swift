//
//  SegmentedChromosomeTests.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/5/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import XCTest

class SegmentedChromosomeTests: XCTestCase {

	let chromosome1: SegmentedChromosome = [[0, 1], [0, 1]]
	
	let chromosome2: SegmentedChromosome = [[1, 0], [1, 0]]
	
	func testInitSizeSeed() {
		var index = 0
		let chromosome = SegmentedChromosome(size: 4) { () -> Bool in
			defer { index += 1 }
			return index % 2 == 0
		}
		
		XCTAssertEqual(chromosome.segments, [[1, 0, 1, 0]])
	}
	
	func testInitSegmentSizesSeed() {
		var index = 0
		let chromosome = SegmentedChromosome(segmentSizes: [2, 2]) { () -> Bool in
			defer { index += 1 }
			return index % 2 == 0
		}
		
		XCTAssertEqual(chromosome.segments, [[1, 0], [1, 0]])
	}
	
	func testGenes() {
		XCTAssertEqual(chromosome1.genes, [0, 1, 0, 1])
	}
	
	func testSubscript() {
		var chromosome = chromosome1
		XCTAssertEqual(chromosome[2], 0)
		
		chromosome[2] = 1
		XCTAssertEqual(chromosome.segments[1][0], 1)
	}
	
	func testRangeSubscript() {
		var chromosome = chromosome1
		XCTAssertEqual(chromosome[1...2], [1, 0])
		
		chromosome[1...2] = [0, 1]
		XCTAssertEqual(chromosome.segments[0][1], 0)
		XCTAssertEqual(chromosome.segments[1][0], 1)
	}
	
	func testTwoPointCrossover() {
		let offspring = SegmentedChromosome.twoPointCrossover(chromosome1, chromosome2: chromosome2, seed: { 0 })
		XCTAssertEqual(offspring.0.segments[0], chromosome2.segments[0])
		XCTAssertEqual(offspring.0.segments[1], chromosome1.segments[1])
		XCTAssertEqual(offspring.1.segments[0], chromosome1.segments[0])
		XCTAssertEqual(offspring.1.segments[1], chromosome2.segments[1])
	}
	
	func testMutation() {
		var chromosome = chromosome1
		var index = 0
		let rate = 0.8
		
		// Mutate the even-indexed genes
		chromosome.mutate(withRate: rate) { () -> Double in
			defer { index += 1 }
			return (index % 2 == 0) ? 0 : rate
		}
		
		XCTAssertEqual(chromosome.genes, [1, 1, 1, 1])
	}
	
	func testNegation() {
		XCTAssertEqual((!chromosome1).segments, [[1, 0], [1, 0]])
	}
	
	func testAddition() {
		let chromosome = chromosome1 + chromosome2
		XCTAssertEqual(chromosome.segments, [[0, 1], [0, 1], [1, 0], [1, 0]])
	}

	func testRemoveFirstN() {
		var chromosome = chromosome1
		chromosome.removeFirst(3)
		XCTAssertEqual(chromosome.segments, [[1]])
	}
}
