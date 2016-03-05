//
//  EvolutionOfLearningTests.swift
//  EvolutionOfLearningTests
//
//  Created by Bryan Hoke on 6/13/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import XCTest
//import EvolutionOfLearning
import GameplayKit

class EvolutionOfLearningTests: XCTestCase {
	
	let inputSize = 8
	
	let activation = sigmoid(λ: 1.0)
	
	var randomInputSeed: NSData {
		let seed = "input"
		return seed.dataUsingEncoding(seed.fastestEncoding)!
	}
	
	var randomInputSource: GKRandomSource {
		return GKARC4RandomSource(seed: randomInputSeed)
	}
	
	var randomInputDistribution: GKRandom {
		return GKRandomDistribution(randomSource: randomInputSource, lowestValue: 0, highestValue: 1)
	}
	
	var randomWeightSeed: NSData {
		let seed = "weight"
		return seed.dataUsingEncoding(seed.fastestEncoding)!
	}
	
	var randomWeightSource: GKRandomSource {
		return GKARC4RandomSource(seed: randomWeightSeed)
	}
	
	var randomWeightDistribution: GKRandom {
		return GKRandomDistribution(randomSource: randomWeightSource, lowestValue: -1, highestValue: 1)
	}
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func makeRandomInputs() -> [Double] {
		var inputs = [Double]()
		let randomInputs = randomInputDistribution
		for _ in 0..<inputSize {
			let input: Double = randomInputs.nextBool() ? 1.0 : 0.0
			inputs.append(input)
		}
		return inputs
	}
	
	func makeRandomWeights() -> [Double] {
		var weights = [Double]()
		let randomWeights = randomWeightDistribution
		for _ in 0..<inputSize {
			let weight = Double(randomWeights.nextUniform())
			weights.append(weight)
		}
		return weights
	}
	
	func testSingleLayerSingleOutputNeuralNetworkPerformance() {
		let inputs = makeRandomInputs(), weights = makeRandomWeights()
		measureBlock() {
			let network = SingleLayerSingleOutputNeuralNetwork(weights: weights, activation: self.activation)
			network.activateWithInputs(inputs)
		}
	}
	
	func testSingleLayerSingleOutputFFNNPerformance() {
		let inputs = makeRandomInputs(), weights = makeRandomWeights()
		measureBlock() {
			let network = SingleLayerSingleOutputFFNN(weights: weights, activation: self.activation)
			network.activateWithInputs(inputs)
		}
	}
	
	func testSingleLayerNeuralNetworkPerformance() {
		let inputs = makeRandomInputs(), weights = [makeRandomWeights()]
		measureBlock() {
			let network = SingleLayerNeuralNetwork(weights: weights, activation: self.activation)
			network.activateWithInputs(inputs)
		}
	}
	
	func testSingleLayerNeuralNetworks() {
		let inputSize = 8
		let activation = sigmoid(λ: 1.0)
		var inputs = [Double]()
		var weights = [Double]()
		for _ in 0..<inputSize {
			inputs.append(randomDouble())
			weights.append(randomDouble())
		}
		var output1: Double = 0
		var output2: Double = 0
		let network1 = SingleLayerSingleOutputNeuralNetwork(weights: weights, activation: activation)
		output1 = network1.activateWithInputs(inputs)
		let network2 = SingleLayerNeuralNetwork(weights: [weights], activation: activation)
		output2 = network2.activateWithInputs(inputs)[0]
		XCTAssertEqual(output1, output2, "The network outputs \(output1) and \(output2) are not equal.")
	}
	
	let deltaRuleBits: [Bool] = [
		1, 1, 0, 1, 1,
		0, 0, 0,
		0, 0, 0,
		0, 0, 0,
		0, 0, 0,
		0, 0, 0,
		0, 0, 0,
		0, 0, 0,
		0, 1, 0,
		1, 1, 0,
		0, 0, 0
	]
	
	let deltaRuleCoefficients = [
		4, 0, 0, 0, 0, 0, 0, 0, -2, 2, 0
	]
	
	let environmentPath = "/Users/bryanhoke/Projects/BDHSoftware/OS X/EvolutionOfLearning/Resources/Environment1.txt"

	func testChalmersLearningRule() {
		// Test rule initialization
		let rule = ChalmersLearningRule(bits: deltaRuleBits)
		XCTAssertEqual(rule.coefficients, deltaRuleCoefficients)
		
		guard
			let tasks = try? TaskParser().tasks(withFileAt: environmentPath),
			let task = tasks.first else {
			return
		}
		
		var network = SingleLayerSingleOutputNeuralNetwork(
			size: task.inputCount + 1,
			activation: sigmoid(λ: 1)) as FeedForwardNeuralNetwork
		
		let error1 = network.testOnTask(task) / Double(task.patterns.count)
		
		rule.trainNetwork(&network, task: task, numberOfTimes: 10)
		
		let error2 = network.testOnTask(task) / Double(task.patterns.count)
		
		XCTAssert(error1 > error2)
	}
}

extension Bool: IntegerLiteralConvertible {
	
	public init(integerLiteral: Int) {
		if integerLiteral == 0 {
			self.init(false)
		}
		else {
			self.init(true)
		}
	}
}
