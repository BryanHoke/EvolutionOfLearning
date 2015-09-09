//
//  Experiment.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/19/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public class Experiment {
	
	var environment: ChalmersEnvironment!
	
	var taskCount = 0
	
	var taskFitnessFuncIndex = 0
	
	var reproductionFuncIndex = 0
	
	var resourceName: String?
	
	var basePath: String {
		return "/Users/bryanhoke/Projects/BDHSoftware/OS X/EvolutionOfLearning"
	}
	
	var resourcePath: String {
		return self.basePath + "/Resources"
	}
	
	var resultsPath: String {
		return self.basePath + "/Results"
	}
	
	var taskFitnessFunc: TaskFitnessFunc {
		return taskFitnessFuncs[taskFitnessFuncIndex]
	}
	
	var taskFitnessFuncs: [TaskFitnessFunc] {
		return [taskFitnessFunc0]
	}
	
	var reproductionFunc: Population -> Population {
		return reproductionFuncs[reproductionFuncIndex]
	}
	
	var reproductionFuncs: [Population -> Population] {
		return [reproductionFunc0]
	}
	
	///
	func configureAlgorithm(algorithm: GeneticAlgorithm) {
		
		environment = ChalmersEnvironment(taskFitnessFunc: taskFitnessFunc, historyLength: 10)
		
		algorithm.fitnessFunc = ChalmersEnvironment.evaluateFitnessOfChromosome(environment)
		
		algorithm.reproductionFunction = reproductionFunc
		
		
	}
	
	///
	let taskFitnessFunc0 = {
		(chromosome chromosome: Chromosome, task: Task) -> Double in
		
		var network = SingleLayerSingleOutputNeuralNetwork(
			size: task.inputCount,
			activation: sigmoid(1)) as FeedForwardNeuralNetwork
		
		let learningRule = ChalmersLearningRule(
			bits: chromosome.genes)
		
		learningRule.trainNetwork(&network, task: task, numberOfTimes: 10)
		
		let error = network.testOnTask(task)
		
		let fitness = 1.0 - (error / Double(task.patterns.count))

		return fitness
	}
	
	///
	let reproductionFunc0 = {
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