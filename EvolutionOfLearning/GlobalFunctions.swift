//
//  GlobalFunctions.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 11/8/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public func sigmoid(x: Double)(lambda: Double) -> Double {
	let f = 1 / (1 + exp(-lambda * x))
	return f
}

public func randomBool() -> Bool {
	return arc4random_uniform(2) == 1
}

public func randomDouble() -> Double {
	let randDouble = Double(Double(arc4random()) / Double(UINT32_MAX))
	return randDouble
}