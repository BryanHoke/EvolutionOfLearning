//
//  GeneticAlgorithm.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/23/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public typealias FitnessFunc = Chromosome -> Double

public protocol GeneticAlgorithmOutput {
	
	func geneticAlgorithm(algorithm: GeneticAlgorithm,
		didEvaluatePopulation pop: Population)
}

/**

*/
public final class GeneticAlgorithm {
	
	///
	public var initializationFunc: (Void -> Population)?
	
	///
	public var fitnessFunc: FitnessFunc?
	
	///
	public var reproductionFunc: (Population -> Population)?
	
	///
	public var output: GeneticAlgorithmOutput?
	
	///
	public func runForNumberOfGenerations(numberOfGenerations: Int) {
		
		///
		func mainRoutine(population: Population, inout generation: Int) {
			
			if let fitnessFunc = self.fitnessFunc {
				
				population.evaluateWithFitnessFunc(fitnessFunc)
			}
			
			output?.geneticAlgorithm(self, didEvaluatePopulation: population)
			
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