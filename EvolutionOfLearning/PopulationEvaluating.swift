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
	
	func evaluate(_ population: inout Population<IndividualType>)
	
}

open class ConcurrentPopulationEvaluator<IndividualType : Individual> : PopulationEvaluating {
	
	public typealias FitnessFunc = (IndividualType.ChromosomeType) -> Double
	
	public typealias PopulationType = Population<IndividualType>
	
	open let fitnessFunc: FitnessFunc
	
	fileprivate var fitnesses: [Double] = []
	
	public init(fitnessFunc: @escaping FitnessFunc) {
		self.fitnessFunc = fitnessFunc
	}
	
	open func evaluate(_ population: inout PopulationType) {
		fitnesses = Array<Double>(repeating: 0, count: population.count)
		let blocks = makeDispatchBlocks(forEvaluating: &population)
        // Use .userInitiated for speed; assumption is that a power supply is connected
		concurrentlyDispatch(blocks, qos: .userInitiated)
		for (index, fitness) in fitnesses.enumerated() {
			population[index].fitness = fitness
		}
	}
	
	fileprivate func makeDispatchBlocks(forEvaluating population: inout PopulationType) -> [()->()] {
		return population.indices.map { index -> ()->() in
			self.makeBlockToEvaluateFitness(of: &population[index], atIndex: index)
		}
	}
	
	fileprivate func makeBlockToEvaluateFitness(of member: inout IndividualType, atIndex index: Int) -> ()->() {
		return {
			self.evaluateFitness(of: &member)
			self.fitnesses[index] = member.fitness
		}
	}
	
	fileprivate func evaluateFitness(of member: inout IndividualType) {
		let chromosome = member.chromosome
		member.fitness = fitnessFunc(chromosome)
	}
	
}
