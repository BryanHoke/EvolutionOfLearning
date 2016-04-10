//
//  FeedForwardNeuralNetwork.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 11/8/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public protocol FeedForwardNeuralNetwork {
	
	/// A value fed forward alongside an input vector to act as a threshold for output activation.
	var bias: Double { get }
	
	/// weights[ i ] = weight from neuron i to output neuron
	var weights: [Double] { get set }
	
	/// Activates the input units with a vector of input values, which are then fed forward through the weights to activate the output unit and produce an output value.
	func activateWithInputs(inputs: [Double]) -> Double
	
	/// Measures the error in the network's response to the pattern inputs compared to the pattern target.
	func testOnPattern(pattern: Pattern) -> Double
	
	/// Measures the total error in the network's repsonse to all patterns in the task.
	func testOnTask(task: Task) -> Double
	
	/// Convenience accessor for the values in `weights`.
	subscript(index: Int) -> Double { get set }
}

extension FeedForwardNeuralNetwork {
	
	/// Measures the error in the network's response to the pattern inputs compared to the pattern target.
	public func testOnPattern(pattern: Pattern) -> Double {
		
		let output = activateWithInputs(pattern.inputs)
		
		let error = abs(pattern.target - output)
		
		return error
	}
	
	/// Measures the total error in the network's repsonse to all patterns in the task.
	public func testOnTask(task: Task) -> Double {
		
		let totalError = task.patterns.reduce(0) { (sum, pattern) in
			sum + testOnPattern(pattern)
		}
		
		return totalError
	}
}