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
	
	func reproduce(population: Population) -> Population {
		var population = population
		
		// Sort population by highest fitness
		population.members.sortInPlace(>)
		
		var selectedPopulation = Population()
		
		// Elitist selection
		selectedPopulation += population.elitismSelectionWithCount(elitismCount)
		
		let size = population.count
		
		// Roulette wheel selection
		let selectionSize = size - elitismCount
		let roulettePop = population.rouletteWheelSelection(newPopulationSize: selectionSize)
		selectedPopulation += roulettePop
		
		// Individuals are selected for crossover uniformly
		let crossoverSize = Int(Double(size) * crossoverRate)
		let branchSelector = Population.uniformSelectionIndices(crossoverSize)
		
		// Perform crossover on portion of population and cloning on the rest
		var newPopulation = selectedPopulation.selectionBranch(branchSelector) {
			(selected: Population, unselected: Population) -> Population in
			
			selected.reproduceWithCrossover(Chromosome.twoPointCrossover)
				+ unselected
		}
		
		// Mutation
		newPopulation = newPopulation.reproduceWithMutation(Chromosome.mutation(mutationRate))
		
		assert(newPopulation.count == population.count)
		
		return newPopulation
	}
	
}
