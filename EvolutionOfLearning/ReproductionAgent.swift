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

public struct ChalmersReproductionAgent {
	
	let elitismCount: Int
	let mutationRate: Double
	let crossoverRate: Double
	
	/// - note: Assumes the population is already sorted
	func reproduce(population: Population) -> Population {
		let newPopulation = nextGenerationPopulation(from: population)
		assert(newPopulation.count == population.count)
		return newPopulation
	}
	
	private func nextGenerationPopulation(from population: Population) -> Population {
		let selectedPopulation = selectPopulation(from: population)
		return reproducedPopulation(from: selectedPopulation)
	}
	
	private func selectPopulation(from population: Population) -> Population {
		var selectedPopulation = Population()
		selectedPopulation.members.reserveCapacity(population.count)
		
		selectedPopulation += elitistSelection(from: population)
		selectedPopulation += rouletteWheelSelection(from: population)
		
		return selectedPopulation
	}
	
	private func elitistSelection(from population: Population) -> Population {
		return population.elitismSelectionWithCount(elitismCount)
	}
	
	private func rouletteWheelSelection(from population: Population) -> Population {
		let selectionSize = population.count - elitismCount
		return population.rouletteWheelSelection(newPopulationSize: selectionSize)
	}
	
	private func reproducedPopulation(from population: Population) -> Population {
		var newPopulation = crossoverPopulation(from: population)
		newPopulation = mutatedPopulation(from: newPopulation)
		return newPopulation
	}
	
	private func crossoverPopulation(from population: Population) -> Population {
		// Individuals are selected for crossover uniformly
		let crossoverSize = Int(Double(population.count) * crossoverRate)
		let branchSelector = Population.uniformSelectionIndices(crossoverSize)
		
		// Perform crossover on portion of population and cloning on the rest
		return population.selectionBranch(branchSelector) {
			(selected, unselected) -> Population in
			selected.reproduceWithCrossover(Chromosome.twoPointCrossover)
				+ unselected
		}
	}
	
	private func mutatedPopulation(from population: Population) -> Population {
		return population.reproduceWithMutation(Chromosome.mutation(mutationRate))
	}
	
}
