//
//  Experiment.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/19/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

// MARK: - Experiment Output Protocol

protocol ExperimentOutput {
	
	func experimentDidBeginNewTrial(experiment: Experiment)
	
	func experiment(experiment: Experiment,
		didEvaluatePopulation pop: Population)
	
	func experimentDidComplete(experiment: Experiment)
}

// MARK: - Experiment

/**

*/
public class Experiment: GeneticAlgorithmOutput {
	
	// MARK: - Instance Properties
	
	///
	let geneticAlgorithm = GeneticAlgorithm()
	
	///
	var environment: FitnessEnvironment!
	
	/// The file path from which the `environment` should be loaded at the start of the experiment.
	var environmentPath: String?
	
	let chromosomeSize = 35
	
	let populationSize = 40
	
	let elitismCount = 2
	
	let crossoverRate = 0.8
	
	let mutationRate = 0.01
	
	let historyLength = 15
	
	let numberOfTrainingEpochs = 10
	
	var taskCount = 30
	
	var numberOfGenerations: Int = 0
	
	var numberOfTrials: Int = 0
	
	var output: ExperimentOutput?
	
	/// The list of fitness values measured per `Chromosome`, in order of recording.
	public var fitnessHistory = [Chromosome: [Double]]()
	
	
	// MARK: - Instance Methods
	
	/// Runs the experiment by configuring the `geneticAlgorithm` and then executing it with a number of generations given by the `numberOfGenerations` for a number of times given by the `numberOfTrials`.
	/// - note: The `numberOfGenerations` and `numberOfTrials` must both be greater than `0` for this method to proceed.
	func run() {
		
		guard numberOfGenerations > 0 && numberOfTrials > 0 && taskCount > 0 else {
			return
		}
		
		configureAlgorithm(geneticAlgorithm)
		
		for _ in 0..<numberOfTrials {
			output?.experimentDidBeginNewTrial(self)
			geneticAlgorithm.runForNumberOfGenerations(numberOfGenerations)
		}
		
		output?.experimentDidComplete(self)
	}
	
	/// Configures the `geneticAlgorithm` before beginning the experiment.
	func configureAlgorithm(algorithm: GeneticAlgorithm) {
		
		let environment = ChalmersEnvironment(taskFitnessFunc: fitnessOfChromosome, historyLength: historyLength)
		
		if let
			path = environmentPath,
			tasks = try? Task.tasksWithFileAtPath(path)
		{
			environment.tasks += tasks
			environment.generateEvolutionaryTasks(taskCount)
		}
		
		self.environment = environment
		
		algorithm.initializationFunc = seeding
		
		algorithm.populationFitnessFunc = fitness
//		algorithm.fitnessFunc = environment.evaluateFitnessOfChromosome
		
		algorithm.reproductionFunc = reproduction
		
		algorithm.output = self
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
	
	/// Evaluates the fitness of all `Individual`s in a `Population`.
	func fitness(inout population: Population) {
		
		environment.evaluateFitness(&population)
		
		// We're done if we aren't tracking fitness histories
		guard historyLength > 0 else {
			return
		}
		
		// Average each member's fitness with historical values
		for member in population {
			
			// Retrieve the member chromosome's fitness history
			var history: [Double] = fitnessHistory[member.chromosome] ?? []
			
			// Update history if there's room for another entry
			if history.count < historyLength {
				
				history.append(member.fitness)
				
				fitnessHistory[member.chromosome] = history
			}
			
			// Update the member's fitness to be the historical average
			member.fitness = history.reduce(0, combine: +) / Double(history.count)
		}
	}
	
	/// Evaluates the fitness of a `Chromosome` on a given `Task`.
	func fitnessOfChromosome(chromosome: Chromosome, onTask task: Task) -> Double {
		
		var network = SingleLayerSingleOutputNeuralNetwork(
			size: task.inputCount + 1,
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
		
		var selectedPopulation = Population()
		
		// Elitist selection
		selectedPopulation += population.elitismSelectionWithCount(elitismCount)
		
		let size = population.count
		
		// Roulette wheel selection
		do {
			let selectionSize = size - elitismCount
			let roulettePop = population.rouletteWheelSelection(newPopulationSize: selectionSize)
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
		
		assert(newPopulation.count == population.count)
		
		return newPopulation
	}
	
	// MARK: Genetic Algorithm Output
	
	public func geneticAlgorithm(algorithm: GeneticAlgorithm,
		didEvaluatePopulation pop: Population)
	{
		output?.experiment(self, didEvaluatePopulation: pop)
	}
}