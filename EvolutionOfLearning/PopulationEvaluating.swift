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

public struct ConcurrentPopulationEvaluator: PopulationEvaluating {
	
	public let fitnessFunc: FitnessFunc
	
	public func evaluate(inout population: Population) {
		let blocks = makeDispatchBlocks(forEvaluating: &population)
		concurrentlyDispatch(blocks, priority: DISPATCH_QUEUE_PRIORITY_HIGH)
	}
	
	private func makeDispatchBlocks(inout forEvaluating population: Population) -> [dispatch_block_t] {
		return population.indices.map { index -> dispatch_block_t in
			self.makeBlockToEvaluateFitness(of: &population[index])
		}
	}
	
	private func makeBlockToEvaluateFitness(inout of member: Individual) -> dispatch_block_t {
		return {
			self.evaluateFitness(of: &member)
		}
	}
	
	private func evaluateFitness(inout of member: Individual) {
		let chromosome = member.chromosome
		member.fitness = fitnessFunc(chromosome)
	}
	
}
