//
//  PopulationEvaluating.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/12/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public protocol PopulationEvaluating {
	
	func evaluate(inout population: Population)
	
}

public class ConcurrentPopulationEvaluator: PopulationEvaluating {
	
	public init(fitnessFunc: FitnessFunc) {
		self.fitnessFunc = fitnessFunc
	}
	
	public let fitnessFunc: FitnessFunc
	
	private var fitnesses: [Double] = []
	
	public func evaluate(inout population: Population) {
		fitnesses = Array<Double>(count: population.count, repeatedValue: 0)
		let blocks = makeDispatchBlocks(forEvaluating: &population)
		concurrentlyDispatch(blocks, priority: DISPATCH_QUEUE_PRIORITY_HIGH)
		for (index, fitness) in fitnesses.enumerate() {
			population[index].fitness = fitness
		}
	}
	
	private func makeDispatchBlocks(inout forEvaluating population: Population) -> [dispatch_block_t] {
		return population.indices.map { index -> dispatch_block_t in
			self.makeBlockToEvaluateFitness(of: &population[index], atIndex: index)
		}
	}
	
	private func makeBlockToEvaluateFitness(inout of member: Individual, atIndex index: Int) -> dispatch_block_t {
		return {
			self.evaluateFitness(of: &member)
			self.fitnesses[index] = member.fitness
		}
	}
	
	private func evaluateFitness(inout of member: Individual) {
		let chromosome = member.chromosome
		member.fitness = fitnessFunc(chromosome)
	}
	
}
