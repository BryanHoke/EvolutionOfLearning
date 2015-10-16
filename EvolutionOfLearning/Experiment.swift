//
//  Experiment.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/19/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

/**

*/
public class Experiment {
	
	// MARK: - Instance Properties
	
	let geneticAlgorithm = GeneticAlgorithm()
	
	var numberOfGenerations: Int = 0
	
	var numberOfTrials: Int = 0
	
	///
	var environment: FitnessEnvironment!
	
	///
	var taskCount = 0
	
	///
	var resourceName: String?
	
	///
	var basePath: String {
		return "/Users/bryanhoke/Projects/BDHSoftware/OS X/EvolutionOfLearning"
	}
	
	///
	var resourcePath: String {
		return self.basePath + "/Resources/"
	}
	
	///
	var resultsPath: String {
		return self.basePath + "/Results/"
	}
	
	///
	weak var dataManager: DataManager?
	
	// MARK: - Instance Methods
	
	///
	func run() {
		
		guard numberOfGenerations > 0 && numberOfTrials > 0 else {
			return
		}
		
		for _ in 0..<numberOfTrials {
			
			geneticAlgorithm.runForNumberOfGenerations(numberOfGenerations)
		}
	}
	
	///
	func configureAlgorithm(algorithm: GeneticAlgorithm) {
		
		environment = ChalmersEnvironment(taskFitnessFunc: fitnessOfChromosome, historyLength: 10)
		
		let tasks = try! Task.tasksWithFileAtPath(resourcePath + "Environment1.txt")
		environment.tasks += tasks
		
		algorithm.initializationFunc = seeding
		
		algorithm.fitnessFunc = ChalmersEnvironment.evaluateFitnessOfChromosome(environment as! ChalmersEnvironment)
		
		algorithm.recordingFunc = dataManager?.recordPopulation
		
		algorithm.reproductionFunc = reproduction
	}
	
	/// Used to generate an initial population.
	func seeding() -> Population {
		
		// Parameters
		let chromosomeSize = 35
		let populationSize = 40
		
		return Population(size: populationSize) { () -> Individual in
			
			let chromosome = Chromosome(size: chromosomeSize) { () -> Bool in
				
				return arc4random_uniform(2) == 1
			}
			
			return Individual(chromosome: chromosome)
		}
	}
	
	/// Used to evaluate the fitness of a `Chromosome` on a given task.
	func fitnessOfChromosome(chromosome: Chromosome, onTask task: Task) -> Double {
		
		var network = SingleLayerSingleOutputNeuralNetwork(
			size: task.inputCount,
			activation: sigmoid(1))
			as FeedForwardNeuralNetwork
		
		let learningRule = ChalmersLearningRule(
			bits: chromosome.genes)
		
		learningRule.trainNetwork(&network, task: task, numberOfTimes: 10)
		
		let error = network.testOnTask(task)
		
		let fitness = 1.0 - (error / Double(task.patterns.count))

		return fitness
	}
	
	/// Used to create the next-generation population by applying selection, mutation, and reproductive operations.
	func reproduction(var population: Population) -> Population {
		
		// Parameters
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
		newPopulation += selectedPopulation.selectionBranch(branchSelector) {
			(selected: Population, unselected: Population) -> Population in
			
			selected.reproduceWithCrossover(Chromosome.twoPointCrossover)
				+ unselected
		}
		
		// Mutation
		newPopulation = newPopulation.reproduceWithMutation(Chromosome.mutation(mutationRate))
		
		return newPopulation
	}
	
}