//
//  Pattern.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/19/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public struct Pattern {
	
	public static func patternsWithInputVectors(inputVectors: [[Double]], targets: [Double]) -> [Pattern] {
		return zip(inputVectors, targets)
			  .map(Pattern.init)
	}
	
	public var inputs = [Double]()
	
	public var target: Double
	
}