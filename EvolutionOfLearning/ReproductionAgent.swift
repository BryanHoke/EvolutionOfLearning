//
//  ReproductionAgent.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/5/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public protocol ReproductionAgent {
	
	associatedtype IndividualType : Individual
	
	func reproduce(population: Population<IndividualType>) -> Population<IndividualType>
	
}

public struct AnyReproductionAgent<IndividualType : Individual> : ReproductionAgent {
	
	public typealias PopulationType = Population<IndividualType>
	
	private let _reproduce: (PopulationType) -> PopulationType
	
	public init<Agent : ReproductionAgent where Agent.IndividualType == IndividualType>(_ agent: Agent) {
		_reproduce = agent.reproduce
	}
	
	public func reproduce(population: PopulationType) -> PopulationType {
		return _reproduce(population)
	}
	
}

/// Reproduces a `Population` using the methodology of Chalmers's experiment.
///
/// Each genome probabilistically makes copies of itself using roulette wheel selection. This yields a new population, `crossoverRate`% of which is subject to two-point crossover, while the remaining members reproduce by cloning. Elitist selection is used for the top `elitismCount` members. In the resulting population, each gene has a `mutationRate`% chance of mutation
public struct ChalmersReproductionAgent<IndividualType : Individual> : ReproductionAgent {
	
	public typealias PopulationType = Population<IndividualType>
	
	public typealias ChromosomeType = IndividualType.ChromosomeType
	
	public var config: ReproductionConfig
	
	public var elitismCount: Int {
		return config.elitismCount
	}
	
	public var mutationRate: Double {
		return config.mutationRate
	}
	
	public var crossoverRate: Double {
		return config.crossoverRate
	}
	
	/// - note: Assumes the population is already sorted
	public func reproduce(population: PopulationType) -> PopulationType {
		let elites = elitistSelection(from: population)
		
		let selected = rouletteWheelSelection(from: population)
		let crossover = crossoverPopulation(from: selected)
		
		var newPopulation = elites + crossover
		mutate(&newPopulation)
		
		assert(newPopulation.count == population.count)
		return newPopulation
	}
	
	// MARK: - Selection
	
	private func elitistSelection(from population: PopulationType) -> PopulationType {
		return population
			.elitistSelection(using: elitismCount)
			.reproduceWithCloning()
	}
	
	private func rouletteWheelSelection(from population: PopulationType) -> PopulationType {
		let selectionSize = population.count - elitismCount
		return population.rouletteWheelSelection(newPopulationSize: selectionSize)
	}
	
	// MARK: - Reproduction
	
	private func crossoverPopulation(from population: PopulationType) -> PopulationType {
		// Individuals are selected for crossover uniformly
		let crossoverSize = Int(Double(population.count + elitismCount) * crossoverRate)
		let branchSelector = PopulationType.uniformSelectionIndices(crossoverSize)
		
		// Perform crossover on selected subpopulation and cloning on the rest
		return population.selectionBranch(branchSelector) {
			(selected: PopulationType, unselected: PopulationType) -> PopulationType in
			selected.reproduceWithCrossover(ChromosomeType.twoPointCrossover)
				+ unselected.reproduceWithCloning()
		}
	}
	
	private func mutate(inout population: PopulationType) {
		population.mutateInPlace(using: mutationRate)
	}
	
}

/// The same as `ChalmersReproductionAgent` except that the elite `Individual`s are copied into the next generation *without* any mutation.
public struct ElitistReproductionAgent<IndividualType : Individual> : ReproductionAgent {
	
	public typealias PopulationType = Population<IndividualType>
	
	public typealias ChromosomeType = IndividualType.ChromosomeType
	
	public var config: ReproductionConfig
	
	public var elitismCount: Int {
		return config.elitismCount
	}
	
	public var mutationRate: Double {
		return config.mutationRate
	}
	
	public var crossoverRate: Double {
		return config.crossoverRate
	}
	
	/// - note: Assumes the population is already sorted
	public func reproduce(population: PopulationType) -> PopulationType {
		let elites = elitistSelection(from: population)
		
		let selected = rouletteWheelSelection(from: population)
		var crossover = crossoverPopulation(from: selected)
		mutate(&crossover)
		
		let newPopulation = elites + crossover
		
		assert(newPopulation.count == population.count)
		return newPopulation
	}
	
	// MARK: - Selection
	
	private func elitistSelection(from population: PopulationType) -> PopulationType {
		return population
			.elitistSelection(using: elitismCount)
			.reproduceWithCloning()
	}
	
	private func rouletteWheelSelection(from population: PopulationType) -> PopulationType {
		let selectionSize = population.count - elitismCount
		return population.rouletteWheelSelection(newPopulationSize: selectionSize)
	}
	
	// MARK: - Reproduction
	
	private func crossoverPopulation(from population: PopulationType) -> PopulationType {
		// Individuals are selected for crossover uniformly
		let crossoverSize = Int(Double(population.count + elitismCount) * crossoverRate)
		let branchSelector = PopulationType.uniformSelectionIndices(crossoverSize)
		
		// Perform crossover on selected subpopulation and cloning on the rest
		return population.selectionBranch(branchSelector) {
			(selected: PopulationType, unselected: PopulationType) -> PopulationType in
			selected.reproduceWithCrossover(ChromosomeType.twoPointCrossover)
				+ unselected.reproduceWithCloning()
		}
	}
	
	private func mutate(inout population: PopulationType) {
		population.mutateInPlace(using: mutationRate)
	}
	
}
