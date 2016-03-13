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
	
	var tasks: [Task] { get }
	
	func makePopulation() -> Population
	
	func fitness(of chromosome: Chromosome) -> Double
	
	func reproduce(population: Population) -> Population
	
}

public struct Environment: EvolutionaryEnvironment {
	
	public var populationSize: Int

	public var fitnessAgent: FitnessAgent
	
	public var reproductionAgent: ReproductionAgent
	
	public var tasks: [Task] {
		return fitnessAgent.tasks
	}
	
	public func makePopulation() -> Population {
		return Population(size: populationSize, seed: { () -> Individual in
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