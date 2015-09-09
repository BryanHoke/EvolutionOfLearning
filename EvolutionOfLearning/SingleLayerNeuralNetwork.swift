//
//  SingleLayerNeuralNetwork.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/13/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation
import Accelerate

public typealias ActivationFunc = Double -> Double

public func sigmoid(x: Double)(lambda: Double) -> Double {
	let f = 1 / (1 + exp(-lambda * x))
	return f
}

public func randomDouble() -> Double {
	let randDouble = Double(Double(arc4random()) / Double(UINT32_MAX))
	return randDouble
}

public protocol FeedForwardNeuralNetwork {
	
	/// A value fed forward alongside an input vector to act as a threshold for output activation.
	var bias: Double { get }
	
	/// weights[ i ] = weight from neuron i to output neuron
	var weights: [Double] { get set }
	
	/// Activates the input units with a vector of input values, which are then fed forward through the weights to activate the output unit and produce an output value.
	func activateWithInputs(var inputs: [Double]) -> Double
	
	/// Measures the error in the network's response to the pattern inputs compared to the pattern target.
	func testOnPattern(pattern: Pattern) -> Double
	
	/// Measures the total error in the network's repsonse to all patterns in the task.
	func testOnTask(task: Task) -> Double
	
	/// Convenience accessor for the values in `weights`.
	subscript(index: Int) -> Double { get set }
	
}

extension FeedForwardNeuralNetwork {
	
	public func testOnPattern(pattern: Pattern) -> Double {
		
		let output = activateWithInputs(pattern.inputs)
		
		let error = abs(pattern.target - output)
		
		return error
	}
	
	public func testOnTask(task: Task) -> Double {
		
		let totalError = task.patterns.reduce(0) { (sum, pattern) in
			sum + testOnPattern(pattern)
		}
		
		return totalError
	}
	
}

/// A single-layer, feed-forward neural network with multiple input units but only a single output unit.
public struct SingleLayerSingleOutputNeuralNetwork: FeedForwardNeuralNetwork {
	
	/// Constructs a network with a number of weights to create, an `ActivationFunc`, and a weight generator `func`.
	public init(size: Int, activation: ActivationFunc, weightGenerator: () -> Double = randomDouble) {
		for _ in 0..<size {
			weights.append(weightGenerator())
		}
		self.activation = activation
	}
	
	/// Constructs a network with weights and an `ActivationFunc`.
	public init(weights: [Double], activation: ActivationFunc) {
		self.weights = weights
		self.activation = activation
	}
	
	/// The function that an output unit applies to the sum of its input to generate its output value.
	public var activation: ActivationFunc
	
	/// A value fed forward alongside an input vector to act as a threshold for output activation.
	public var bias: Double {
		return -1
	}
	
	/// The number of weights in the network
	public var count: Int {
		return weights.count
	}
	
	/// weights[ i ] = weight from neuron i to output neuron
	public var weights = [Double]()
	
	/// Activates the network's input units with a vector of input values, which are then fed forward through the weights to activate the output unit and compute an output value.
	public func activateWithInputs(var inputs: [Double]) -> Double {
		inputs.append(bias)
		let output = activation(cblas_ddot(Int32(count), weights, 1, inputs, 1))
		return output
	}
	
	/// Convenience access into `weights`.
	public subscript(index: Int) -> Double {
		get {
			return weights[index]
		}
		set {
			weights[index] = newValue
		}
	}
	
}

/// A single-layer, feed-forward neural network with multiple input units but only a single output unit.
public final class SingleLayerSingleOutputFFNN: FeedForwardNeuralNetwork {
	
	public init(size: Int, activation: ActivationFunc, weightGenerator: () -> Double = randomDouble) {
		for _ in 0..<size {
			weights.append(weightGenerator())
		}
		self.activation = activation
	}
	
	public init(weights: [Double], activation: ActivationFunc) {
		self.weights = weights
		self.activation = activation
	}
	
	/// The function that an output unit applies to the sum of its input to generate its output value.
	public var activation: ActivationFunc
	
	/// A value fed forward alongside an input vector to act as a threshold for output activation.
	public var bias: Double {
		return -1
	}
	
	/// The number of weights in the network
	public var count: Int {
		return weights.count
	}
	
	/// weights[ i ] = weight from neuron i to output neuron
	public var weights = [Double]()
	
	public func activateWithInputs(var inputs: [Double]) -> Double {
		inputs.append(-1)
		let output = activation(cblas_ddot(Int32(weights.count), weights, 1, inputs, 1))
		return output
	}
	
	public subscript(index: Int) -> Double {
		get {
			return weights[index]
		}
		set {
			weights[index] = newValue
		}
	}
	
}

/// A single-layer, feed-forward neural network with multiple input units and multiple output units.
public struct SingleLayerNeuralNetwork {
	
	public init(inputSize: Int, outputSize: Int, activation: ActivationFunc, weightGenerator: () -> Double = randomDouble) {
		for _ in 0..<outputSize {
			var weights_i = [Double]()
			for _ in 0..<inputSize {
				weights_i.append(weightGenerator())
			}
			weights.append(weights_i)
		}
		self.activation = activation
	}
	
	public init(weights: [[Double]], activation: ActivationFunc) {
		self.weights = weights
		self.activation = activation
	}
	
	/// The function that an output unit applies to the sum of its input to generate its output value.
	public var activation: ActivationFunc
	
	/// weights[ i ][ j ] = weight from neuron j to neuron i
	public var weights = [[Double]]()
	
	public func activateWithInputs(var inputs: [Double]) -> [Double] {
		inputs.append(-1)
		let outputs = weights.map { weights_i in
			cblas_ddot(Int32(weights_i.count), weights_i, 1, inputs, 1)
			}.map { activation($0) }
		return outputs
	}
	
}