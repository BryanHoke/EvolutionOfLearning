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

public protocol Environment {
	
	associatedtype IndividualType : Individual
	
	var tasks: [Task] { get }
	
	func makePopulation() -> Population<IndividualType>
	
	func fitness(of chromosome: IndividualType.ChromosomeType) -> Double
	
	func reproduce(population: Population<IndividualType>) -> Population<IndividualType>
	
}

public struct AnyEnvironment<IndividualType : Individual> : Environment {
	
	public typealias PopulationType = Population<IndividualType>
	
	public var tasks: [Task]
	
	private let _makePopulation: () -> PopulationType
	
	private let _fitness: (IndividualType.ChromosomeType) -> Double
	
	private let _reproduce: (PopulationType) -> PopulationType
	
	public init<EnvironmentType : Environment where EnvironmentType.IndividualType == IndividualType>(environment: EnvironmentType) {
		tasks = environment.tasks
		_makePopulation = environment.makePopulation
		_fitness = environment.fitness(of:)
		_reproduce = environment.reproduce
	}
	
	public func makePopulation() -> Population<IndividualType> {
		return _makePopulation()
	}
	
	public func fitness(of chromosome: IndividualType.ChromosomeType) -> Double {
		return _fitness(chromosome)
	}
	
	public func reproduce(population: Population<IndividualType>) -> Population<IndividualType> {
		return _reproduce(population)
	}
	
}

public struct EvolutionaryEnvironment<IndividualType : Individual> : Environment {
	
	public typealias ChromosomeType = IndividualType.ChromosomeType
	
	public var config: EnvironmentConfig
	
	public var populationSize: Int {
		return config.populationSize
	}

	public var fitnessAgent: AnyFitnessAgent<ChromosomeType>
	
	public var reproductionAgent: AnyReproductionAgent<IndividualType>
	
	public var tasks: [Task] {
		return fitnessAgent.tasks
	}
	
	public func makePopulation() -> Population<IndividualType> {
		return Population(size: populationSize, seed: { () -> IndividualType in
			IndividualType.init(chromosome: self.fitnessAgent.seed())
		})
	}
	
	public func fitness(of chromosome: IndividualType.ChromosomeType) -> Double {
		return fitnessAgent.fitness(of: chromosome)
	}
	
	public func reproduce(population: Population<IndividualType>) -> Population<IndividualType> {
		return reproductionAgent.reproduce(population)
	}
	
}