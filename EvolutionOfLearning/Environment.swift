//
//  Environment.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/19/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation
import Darwin

public typealias TaskFitnessFunc = (Chromosome, Task) -> Double

public protocol EvolutionaryEnvironment {
	
	func makePopulation(size size: Int) -> Population
	
	func fitness(of chromosome: Chromosome) -> Double
	
	func reproduce(population: Population) -> Population
	
}

public struct Environment: EvolutionaryEnvironment {

	let fitnessAgent: FitnessAgent
	
	let reproductionAgent: ReproductionAgent
	
	public func makePopulation(size size: Int) -> Population {
		return Population(size: size, seed: { () -> Individual in
			Individual(chromosome: self.fitnessAgent.seed())
		})
	}
	
	public func fitness(of chromosome: Chromosome) -> Double {
		return fitnessAgent.fitness(of: chromosome)
	}
	
	public func reproduce(population: Population) -> Population {
		return reproductionAgent.reproduce(population)
	}
	
}