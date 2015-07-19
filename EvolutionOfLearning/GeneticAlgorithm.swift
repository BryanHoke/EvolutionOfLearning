//
//  GeneticAlgorithm.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/23/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public protocol GeneticAlgorithmDelegate: class {
	
	func geneticAlgorithm(geneticAlgorithm: GeneticAlgorithm, didEvaluatePopulation population: Population)
	
}

public final class GeneticAlgorithm {
	
	public var initializationFunction: (Void -> Population)?
	
	public var fitnessFunction: (Individual -> Double)?
	
	public var recordingFunction: (Population -> Void)?
	
	public var reproductionFunction: (Population -> Population)?
	
	public func runForNumberOfGenerations(numberOfGenerations: Int) {
		
		func evaluatePopulation(population: Population) {
			for individual in population {
				individual.fitness = fitnessFunction?(individual) ?? 0
			}
		}
		
		func mainRoutine(population: Population, inout generation: Int) {
			evaluatePopulation(population)
			self.recordingFunction?(population)
			generation++
		}
		
		guard numberOfGenerations > 0, var population = initializationFunction?() else {
			return
		}
		
		var generation = 0
		
		mainRoutine(population, generation: &generation)
		
		while generation < numberOfGenerations {
			population = reproductionFunction?(population) ?? population
			mainRoutine(population, generation: &generation)
		}
	}
	
}