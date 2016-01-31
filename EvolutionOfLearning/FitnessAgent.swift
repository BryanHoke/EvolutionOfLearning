//
//  FitnessAgent.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 11/7/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public protocol FitnessAgent {
	
	func evaluateFitness(inout population: Population)
	
	
}

public struct EnvironmentalFitnessAgent: FitnessAgent {
	
	public var historyLength = 15
	
	/// The list of fitness values measured per `Chromosome`, in order of recording.
	public var fitnessHistory = [Chromosome: [Double]]()
	
	public func evaluateFitness(inout population: Population) {
		
	}
}