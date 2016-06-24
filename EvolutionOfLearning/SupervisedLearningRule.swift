//
//  SupervisedLearningRule.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/25/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public protocol SupervisedLearningRule {

	func train(inout network: FeedForwardNeuralNetwork,
		on pattern: Pattern)
	
	func train(inout network: FeedForwardNeuralNetwork,
		on task: Task)
	
	func train(inout network: FeedForwardNeuralNetwork,
		on task: Task,
		numberOfTimes: Int)
}

public extension SupervisedLearningRule {
	
	func train(inout network: FeedForwardNeuralNetwork, on task: Task) {
		for pattern in task.patterns {
			train(&network, on: pattern)
		}
	}
	
	func train(inout network: FeedForwardNeuralNetwork, on task: Task, numberOfTimes: Int) {
		for _ in 0..<numberOfTimes {
			train(&network, on: task)
		}
	}
	
}

public struct ChalmersLearningRule: SupervisedLearningRule {
	
	public var coefficients: [Double]
	
	public let weightLimit = 20.0
	
	public subscript(index: Int) -> Double {
		return self.coefficients[index]
	}
	
	public init(coefficients: [Double]) {
		self.coefficients = coefficients
	}
	
	public init(bits: [Bool]) {
		var coefficients = [Double]()
		// Compute k_0
		var bits_0 = [Bool]()
		for i in 1..<5 {
			bits_0 += [bits[i]]
		}
		var k_0: Double = Double(encodedInt(from: bits_0))
		if k_0 != 0 {
			k_0 = pow(2.0, k_0 - 9)
			k_0 = bits[0] == true ? k_0 : -k_0
		}
		coefficients += [k_0]
		// Compute k_1...11
		for i in 1..<11 {
			let signIndex = 5 + 3 * (i - 1)
			let sign: Int = bits[signIndex] == true ? 1 : -1
			var bits_i = [Bool]()
			for j in (signIndex + 1)..<(signIndex + 3) {
				bits_i += [bits[j]]
			}
			var k_i = Double(encodedInt(from: bits_i))
			if k_i != 0 {
				k_i = pow(2, k_i - 1)
				k_i *= Double(sign)
			}
			coefficients += [k_i]
		}
		self.init(coefficients: coefficients)
	}
	
	public func train(inout network: FeedForwardNeuralNetwork, on pattern: Pattern) {
		let output = network.activateWithInputs(pattern.inputs)
		for i in 0...pattern.inputs.count {
			let input = i < pattern.inputs.count ? pattern.inputs[i] : network.bias
			let target = pattern.target
			let weight = network[i]
			let delta = weightDelta(weight: weight, input: input, output: output, target: target)
			var newWeight = weight + delta
			newWeight = max(min(newWeight, weightLimit), -weightLimit)
			assert(newWeight >= -weightLimit && newWeight <= weightLimit)
			network[i] = newWeight
		}
	}
	
	public func weightDelta(weight weight: Double, input: Double, output: Double, target: Double) -> Double {
		var delta: Double = 0
		delta += self[1] * weight
		delta += self[2] * input
		delta += self[3] * output
		delta += self[4] * target
		delta += self[5] * weight * input
		delta += self[6] * weight * output
		delta += self[7] * weight * target
		delta += self[8] * input * output
		delta += self[9] * input * target
		delta += self[10] * output * target
		delta *= self[0]
		return delta
	}
	
}