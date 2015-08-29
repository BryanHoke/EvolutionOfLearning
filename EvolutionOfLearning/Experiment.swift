//
//  Experiment.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/19/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public class Experiment {
	
	let fitnessFunc1 = {
		(chromosome chromosome: Chromosome, task: Task) -> Double in
		
		var network = SingleLayerSingleOutputNeuralNetwork(
			size: task.inputCount,
			activation: sigmoid(1))
			as FeedForwardNeuralNetwork
		
		let learningRule = ChalmersLearningRule(
			bits: chromosome.genes)
		
		learningRule.trainNetwork(&network, task: task, numberOfTimes: 10)
		
		// TODO: Finish
		return 0
	}
	
	let reproductionFunc1 = {
		(var population: Population) -> Population in
		
		let elitismCount = 1
		let crossoverRate = 0.8
		let mutationRate = 0.01
		let size = population.count
		let crossoverSize = Int(Double(size) * crossoverRate)
		
		var newPopulation = Population()
		
		population.members.sortInPlace(>)
		
		// Elitist selection
		var selectedPopulation = population.elitismSelectionWithCount(elitismCount)
		
		do { // Roulette wheel selection
			var indices = Set<Int>()
			for i in 0..<elitismCount {
				indices.insert(i)
			}
			
			selectedPopulation += population.rouletteWheelSelection(newPopulationSize: size - elitismCount, excludedIndices: indices)
		}
		
		let branchSelector = Population.uniformSelectionIndices(crossoverSize)
		
		// Perform crossover on portion of population proportional to crossoverRate, and cloning on the rest
		selectedPopulation.selectionBranch(branchSelector) {
			(selected: Population, unselected: Population) in
			
			newPopulation += selected.reproduceWithCrossover(Chromosome.twoPointCrossover)
			
			newPopulation += unselected
		}
		
		// Mutation
		newPopulation = newPopulation.reproduceWithMutation(Chromosome.mutation(mutationRate))
		
		return newPopulation
	}
	
}