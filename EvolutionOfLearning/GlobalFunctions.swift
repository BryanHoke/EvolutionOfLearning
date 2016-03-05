//
//  GlobalFunctions.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 11/8/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public typealias ActivationFunc = Double -> Double

public func sigmoid(λ λ: Double) -> ActivationFunc {
	return { x in
		1 / (1 + exp(-λ * x))
	}
}

public func pow(base: Int, _ exponent: Int) -> Int {
	return Int(pow(Double(base), Double(exponent)))
}

public func randomBool() -> Bool {
	return arc4random_uniform(2) == 1
}

public func randomDouble() -> Double {
	let randDouble = Double(Double(arc4random()) / Double(UINT32_MAX))
	return randDouble
}

func encodedInt(from bits: [Bool]) -> Int {
	return bits.reverse().enumerate().reduce(0, combine: { (sum, pair: (i: Int, bit: Bool)) -> Int in
		sum + (pair.bit ? pow(2, pair.i) : 0)
	})
}

// TODO: Test
public func exponentOffset(bitCount count: Int, cap: Int) -> Int {
	return pow(2, count - 1) - 1 - cap
}

// TODO: Test
func signedExponentialEncoding(with exponentOffset: Int) -> (bits: [Bool]) -> Double {
	return { bits -> Double in
		let base = encodedInt(from: bits)
		var value = 0.0
		if base != 0 {
			value = pow(2.0, Double(base - exponentOffset))
			let signBit = bits[0]
			value = signBit ? value : -value
		}
		return value
	}
}

// TODO: Test
func decodeWeights(from bits: [Bool], bitsPerWeight: Int, layerSize: Int, encoding: [Bool] -> Double) -> [Double] {
	var weights: [Double] = []
	for i in 0..<layerSize {
		let start = i * bitsPerWeight,
		end = start + bitsPerWeight
		let weightBits = [Bool](bits[start..<end])
		let weight = encoding(weightBits)
		weights.append(weight)
	}
	return weights
}
