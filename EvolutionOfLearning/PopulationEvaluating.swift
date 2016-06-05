//
//  PopulationEvaluating.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/12/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public protocol PopulationEvaluating {
	
	associatedtype IndividualType : Individual
	
	func evaluate(inout population: Population<IndividualType>)
	
}

public class ConcurrentPopulationEvaluator<IndividualType : Individual> : PopulationEvaluating {
	
	public typealias FitnessFunc = (IndividualType.ChromosomeType) -> Double
	
	public typealias PopulationType = Population<IndividualType>
	
	public let fitnessFunc: FitnessFunc
	
	private var fitnesses: [Double] = []
	
	public init(fitnessFunc: FitnessFunc) {
		self.fitnessFunc = fitnessFunc
	}
	
	public func evaluate(inout population: PopulationType) {
		fitnesses = Array<Double>(count: population.count, repeatedValue: 0)
		let blocks = makeDispatchBlocks(forEvaluating: &population)
		concurrentlyDispatch(blocks, priority: DISPATCH_QUEUE_PRIORITY_HIGH)
		for (index, fitness) in fitnesses.enumerate() {
			population[index].fitness = fitness
		}
	}
	
	private func makeDispatchBlocks(inout forEvaluating population: PopulationType) -> [dispatch_block_t] {
		return population.indices.map { index -> dispatch_block_t in
			self.makeBlockToEvaluateFitness(of: &population[index], atIndex: index)
		}
	}
	
	private func makeBlockToEvaluateFitness(inout of member: IndividualType, atIndex index: Int) -> dispatch_block_t {
		return {
			self.evaluateFitness(of: &member)
			self.fitnesses[index] = member.fitness
		}
	}
	
	private func evaluateFitness(inout of member: IndividualType) {
		let chromosome = member.chromosome
		member.fitness = fitnessFunc(chromosome)
	}
	
}
