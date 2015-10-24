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
	
	///
	var environment: FitnessEnvironment!
	
	/// The file path from which the `environment` should be loaded at the start of the experiment.
	var environmentPath: String?
	
	///
	weak var dataManager: DataManager?
	
	let chromosomeSize = 35
	
	let populationSize = 40
	
	let elitismCount = 1
	
	let crossoverRate = 0.8
	
	let mutationRate = 0.01
	
	let historyLength = 10
	
	let numberOfTrainingEpochs = 10
	
	var taskCount = 0
	
	var numberOfGenerations: Int = 0
	
	var numberOfTrials: Int = 0
	
	// MARK: - Instance Methods
	
	/// Runs the experiment by configuring the `geneticAlgorithm` and then executing it with a number of generations given by the `numberOfGenerations` for a number of times given by the `numberOfTrials`.
	/// - note: The `numberOfGenerations` and `numberOfTrials` must both be greater than `0` for this method to do anything.
	func run() {
		guard numberOfGenerations > 0 && numberOfTrials > 0 else {
			return
		}
		
		configureAlgorithm(geneticAlgorithm)
		
		for _ in 0..<numberOfTrials {
			dataManager?.beginNewTrial()
			geneticAlgorithm.runForNumberOfGenerations(numberOfGenerations)
		}
	}
	
	/// Configures the `geneticAlgorithm` before beginning the experiment.
	func configureAlgorithm(algorithm: GeneticAlgorithm) {
		environment = ChalmersEnvironment(taskFitnessFunc: fitnessOfChromosome, historyLength: historyLength)
		
		if let
			path = environmentPath,
			tasks = try? Task.tasksWithFileAtPath(path) {
				environment.tasks += tasks
		}
		
		algorithm.initializationFunc = seeding
		
		algorithm.fitnessFunc = environment.evaluateFitnessOfChromosome
		
		algorithm.recordingFunc = dataManager?.recordPopulation
		
		algorithm.reproductionFunc = reproduction
	}
	
	/// Generates an initial `Population` at the beginning of each trial of the experiment.
	func seeding() -> Population {
		
		// Initial population has randomly generated individuals
		return Population(size: populationSize) { () -> Individual in
			
			// Initial individuals have randomly generated chromosomes
			let chromosome = Chromosome(size: self.chromosomeSize) { () -> Bool in
				
				// Initial chromosomes have randomly generated genes
				arc4random_uniform(2) == 1
			}
			return Individual(chromosome: chromosome)
		}
	}
	
	/// Evaluates the fitness of a `Chromosome` on a given `Task`.
	func fitnessOfChromosome(chromosome: Chromosome, onTask task: Task) -> Double {
		
		var network = SingleLayerSingleOutputNeuralNetwork(
			size: task.inputCount,
			activation: sigmoid(1)) as FeedForwardNeuralNetwork
		
		let learningRule = ChalmersLearningRule(
			bits: chromosome.genes)
		
		learningRule.trainNetwork(&network, task: task, numberOfTimes: numberOfTrainingEpochs)
		
		let error = network.testOnTask(task)
		
		let fitness = 1.0 - (error / Double(task.patterns.count))

		return fitness
	}
	
	/// Creates the next-generation `Population`s by applying selection, mutation, and reproductive operations.
	func reproduction(var population: Population) -> Population {
		
		// Sort population by highest fitness
		population.members.sortInPlace(>)
		
		// Elitist selection
		var selectedPopulation = population.elitismSelectionWithCount(elitismCount)
		
		let size = population.count
		
		// Roulette wheel selection
		do {
			// The elite inviduals do not participate in roulette wheel
			let selectionSize = size - elitismCount
			var eliteIndices = Set<Int>()
			for i in 0..<elitismCount {
				eliteIndices.insert(i)
			}
			
			let roulettePop = population.rouletteWheelSelection(newPopulationSize: selectionSize, excludedIndices: eliteIndices)
			selectedPopulation += roulettePop
		}
		
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
		
		return newPopulation
	}
}