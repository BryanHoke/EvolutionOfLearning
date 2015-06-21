//
//  EvolutionOfLearningGeneticAlgorithmTests.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/18/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import XCTest

class EvolutionOfLearningGeneticAlgorithmTests: XCTestCase {
	
	var tChromosome1: Chromosome = "01010010100101001010101001010010100101"

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
	
	func testDRand48Seed() {
		let size = 20
		let seed = 0
		srand48(seed)
		var randArray1 = [Double](), randArray2 = randArray1
		for _ in 0..<size {
			randArray1.append(drand48())
		}
		srand48(seed)
		for _ in 0..<size {
			randArray2.append(drand48())
		}
		XCTAssert(randArray1 == randArray2)
	}
	
	func testChromosomeMutation() {
		var testChromosome1 = tChromosome1, testGenes = testChromosome1.genes
		let seed = 0, mutationRate = 0.5
		testChromosome1.mutateWithRate(mutationRate, seed: seed)
		srand48(seed)
		let testGenesMutated1 = testGenes.map { (drand48() >= mutationRate) ? !$0 : $0 }
		XCTAssert(testChromosome1.genes == testGenesMutated1)
		srand48(seed)
		var mutationIndices = Set<Int>()
		for index in 0..<testGenes.count {
			if drand48() >= mutationRate {
				mutationIndices.insert(index)
			}
		}
		var testGenesMutated2 = testGenes
		for mutationIndex in mutationIndices {
			let mutatedGene = !testGenesMutated2[mutationIndex]
			testGenesMutated2[mutationIndex] = mutatedGene
		}
		XCTAssert(testGenesMutated2 == testGenesMutated1)
		var testChromosome2 = tChromosome1
		testChromosome2.mutateAtIndices(mutationIndices)
		XCTAssert(testChromosome2 == testChromosome1)
	}

}
