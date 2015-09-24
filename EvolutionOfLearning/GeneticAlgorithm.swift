//
//  GeneticAlgorithm.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/23/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public typealias FitnessFunc = Chromosome -> Double

public protocol GeneticAlgorithmDelegate: class {
	
	func geneticAlgorithm(geneticAlgorithm: GeneticAlgorithm, didEvaluatePopulation population: Population)
	
}

/**

*/
public final class GeneticAlgorithm {
	
	///
	public var initializationFunc: (Void -> Population)?
	
	///
	public var fitnessFunc: FitnessFunc?
	
	///
	public var recordingFunc: (Population -> Void)?
	
	///
	public var reproductionFunc: (Population -> Population)?
	
	///
	public func runForNumberOfGenerations(numberOfGenerations: Int) {
		
		///
		func mainRoutine(population: Population, inout generation: Int) {
			
			if let fitnessFunc = self.fitnessFunc {
				
				population.evaluateWithFitnessFunc(fitnessFunc)
			}
			
			self.recordingFunc?(population)
			
			generation++
		}
		
		guard numberOfGenerations > 0, var population = initializationFunc?() else {
			return
		}
		
		var generation = 0
		
		mainRoutine(population, generation: &generation)
		
		while generation < numberOfGenerations {
			
			population = reproductionFunc?(population) ?? population
			
			mainRoutine(population, generation: &generation)
		}
	}
	
}