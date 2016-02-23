//
//  NeuralNetworkTests.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 2/21/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import XCTest

class NeuralNetworkTests: XCTestCase {

	func testSingleLayerSingleOutputNeuralNetwork() {
		let weights = [1, 2, -3, 0.5]
		let activation = sigmoid(λ: 1)
		let network = SingleLayerSingleOutputNeuralNetwork(weights: weights, activation: activation)
		let inputs = [1.0, 1.0, 1.0]
		let output = network.activateWithInputs(inputs)
		XCTAssertEqual(output, 0.37754066879814541)
	}

}
