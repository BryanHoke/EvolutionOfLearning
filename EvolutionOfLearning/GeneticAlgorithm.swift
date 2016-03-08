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

public struct GeneticAlgorithm {
	
	public let environment: EvolutionaryEnvironment
	
	public let onPopulationEvaluated: ((population: Population) -> Void)?
	
	public func run(forGenerations numberOfGenerations: Int, populationSize: Int, initialPopulation: Population? = nil) {
		var population = initialPopulation ?? environment.makePopulation(size: populationSize)
		for _ in 0..<numberOfGenerations {
			runGeneration(of: &population)
		}
	}
	
	private func runGeneration(inout of population: Population) {
		evaluateFitness(of: &population)
		population.members.sortInPlace(>)
		onPopulationEvaluated?(population: population)
		population = environment.reproduce(population)
	}
	
	private func evaluateFitness(inout of population: Population) {
		let dispatcher = ConcurrentDispatcher(queuePriority: DISPATCH_QUEUE_PRIORITY_HIGH)
		let blocks = dispatchBlocks(forEvaluating: &population)
		dispatcher.concurrentlyDispatch(blocks)
	}
	
	private func dispatchBlocks(inout forEvaluating population: Population) -> [dispatch_block_t] {
		var blocks: [dispatch_block_t] = []
		population.visitMembers { member in
			blocks.append({
				let chromosome = member.chromosome
				let fitness = self.environment.fitness(of: chromosome)
				member.fitness = fitness
			})
		}
		return blocks
	}
	
}
