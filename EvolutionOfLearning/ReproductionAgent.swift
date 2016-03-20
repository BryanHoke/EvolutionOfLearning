//
//  ReproductionAgent.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/5/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public protocol ReproductionAgent {
	
	func reproduce(population: Population) -> Population
	
}

/// Reproduces a `Population` using the methodology of Chalmers's experiment.
///
/// Each genome probabilistically makes copies of itself using roulette wheel selection. This yields a new population, `crossoverRate`% of which is subject to two-point crossover, while the remaining members reproduce by cloning. Elitist selection is used for the top `elitismCount` members. In the resulting population, each gene has a `mutationRate`% chance of mutation
public struct ChalmersReproductionAgent: ReproductionAgent {
	
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
	public func reproduce(population: Population) -> Population {
		let elites = elitistSelection(from: population)
		
		let selected = rouletteWheelSelection(from: population)
		let crossover = crossoverPopulation(from: selected)
		
		var newPopulation = elites + crossover
		mutate(&newPopulation)
		
		assert(newPopulation.count == population.count)
		return newPopulation
	}
	
	// MARK: - Selection
	
	private func elitistSelection(from population: Population) -> Population {
		return population
			.elitistSelection(using: elitismCount)
			.reproduceWithCloning()
	}
	
	private func rouletteWheelSelection(from population: Population) -> Population {
		let selectionSize = population.count - elitismCount
		return population.rouletteWheelSelection(newPopulationSize: selectionSize)
	}
	
	// MARK: - Reproduction
	
	private func crossoverPopulation(from population: Population) -> Population {
		// Individuals are selected for crossover uniformly
		let crossoverSize = Int(Double(population.count + elitismCount) * crossoverRate)
		let branchSelector = Population.uniformSelectionIndices(crossoverSize)
		
		// Perform crossover on selected subpopulation and cloning on the rest
		return population.selectionBranch(branchSelector) {
			(selected, unselected) -> Population in
			selected.reproduceWithCrossover(Chromosome.twoPointCrossover)
				+ unselected.reproduceWithCloning()
		}
	}
	
	private func mutate(inout population: Population) {
		population.visitMembers { (inout member: Individual) in
			member.chromosome.mutateInPlaceWithRate(self.mutationRate)
		}
	}
	
}
