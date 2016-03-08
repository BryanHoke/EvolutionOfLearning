//
//  GeneticAlgorithm.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/23/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public typealias FitnessFunc = Chromosome -> Double

public typealias PopulationFitnessFunc = inout Population -> ()

public protocol GeneticAlgorithmOutput {
	
	func geneticAlgorithm(algorithm: _GeneticAlgorithm,
		didEvaluatePopulation pop: Population)
}

public struct GeneticAlgorithm {
	
	public init(environment: EvolutionaryEnvironment) {
		self.environment = environment
	}
	
	public var environment: EvolutionaryEnvironment
	
	public func run(forGenerations numberOfGenerations: Int, populationSize: Int, initialPopulation: Population? = nil) {
		var population = initialPopulation ?? environment.makePopulation(size: populationSize)
		
		for _ in 0..<numberOfGenerations {
			evaluateFitness(of: &population)
			population = environment.reproduce(population)
		}
	}
	
	private func evaluateFitness(inout of population: Population) {
		var blocks: [dispatch_block_t] = []
		for member in population {
			blocks.append({
				let chromosome = member.chromosome
				let fitness = self.environment.fitness(of: chromosome)
				member.fitness = fitness
			})
		}
		let dispatcher = ConcurrentDispatcher(queuePriority: DISPATCH_QUEUE_PRIORITY_HIGH)
		dispatcher.concurrentlyDispatch(blocks)
	}
	
}

/**

*/
public final class _GeneticAlgorithm {
	
	///
	public var initializationFunc: (Void -> Population)?
	
	///
	public var fitnessFunc: FitnessFunc?
	
	///
	public var populationFitnessFunc: PopulationFitnessFunc?
	
	///
	public var reproductionFunc: (Population -> Population)?
	
	///
	public var output: GeneticAlgorithmOutput?
	
	///
	public func runForNumberOfGenerations(numberOfGenerations: Int) {
		
		///
		func mainRoutine(var population: Population, inout generation: Int) {
			
			if let popFitnessFunc = self.populationFitnessFunc {
				
				popFitnessFunc(&population)
			}
			else if let fitnessFunc = self.fitnessFunc {
				
				population.evaluateWithFitnessFunc(fitnessFunc)
			}
			
			// Sort population by highest fitness
			population.members.sortInPlace(>)
			
			print("#\(generation): \(population.averageFitness)")
			
			output?.geneticAlgorithm(self, didEvaluatePopulation: population)
			
			generation += 1
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