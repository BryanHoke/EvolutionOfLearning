//
//  SingleLayerNeuralNetwork.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/13/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation
import Accelerate

public typealias ActivationFunction = Double -> Double

public func sigmoid(x: Double)(lambda: Double) -> Double {
	let f = 1 / (1 + exp(-lambda * x))
	return f
}

public func randomDouble() -> Double {
	let randDouble = Double(Double(arc4random()) / Double(UINT32_MAX))
	return randDouble
}

public struct SingleLayerSingleOutputNeuralNetwork {
	
	public init(size: Int, activation: ActivationFunction, weightGenerator: () -> Double = randomDouble) {
		for _ in 0..<size {
			weights.append(weightGenerator())
		}
		self.activation = activation
	}
	
	public init(weights: [Double], activation: ActivationFunction) {
		self.weights = weights
		self.activation = activation
	}
	
	/// weights[ i ] = weight from neuron i to output neuron
	public var weights = [Double]()
	
	public var activation: ActivationFunction
	
	public func activateWithInputs(var inputs: [Double]) -> Double {
		inputs.append(-1)
		let output = activation(cblas_ddot(Int32(weights.count), weights, 1, inputs, 1))
		return output
	}
	
}

public final class SingleLayerSingleOutputFFNN {
	
	public init(size: Int, activation: ActivationFunction, weightGenerator: () -> Double = randomDouble) {
		for _ in 0..<size {
			weights.append(weightGenerator())
		}
		self.activation = activation
	}
	
	public init(weights: [Double], activation: ActivationFunction) {
		self.weights = weights
		self.activation = activation
	}
	
	/// weights[ i ] = weight from neuron i to output neuron
	public var weights = [Double]()
	
	public var activation: ActivationFunction
	
	public func activateWithInputs(var inputs: [Double]) -> Double {
		inputs.append(-1)
		let output = activation(cblas_ddot(Int32(weights.count), weights, 1, inputs, 1))
		return output
	}
	
}

public struct SingleLayerNeuralNetwork {
	
	public init(inputSize: Int, outputSize: Int, activation: ActivationFunction, weightGenerator: () -> Double = randomDouble) {
		for _ in 0..<outputSize {
			var weights_i = [Double]()
			for _ in 0..<inputSize {
				weights_i.append(weightGenerator())
			}
			weights.append(weights_i)
		}
		self.activation = activation
	}
	
	public init(weights: [[Double]], activation: ActivationFunction) {
		self.weights = weights
		self.activation = activation
	}
	
	/// weights[ i ][ j ] = weight from neuron j to neuron i
	public var weights = [[Double]]()
	
	public var activation: Double -> Double
	
	public func activateWithInputs(var inputs: [Double]) -> [Double] {
		inputs.append(-1)
		let outputs = weights.map { weights_i in
			cblas_ddot(Int32(weights_i.count), weights_i, 1, inputs, 1)
			}.map { activation($0) }
		return outputs
	}
	
}