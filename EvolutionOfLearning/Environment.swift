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

public protocol EvolutionaryEnvironment {
	
	func makePopulation(size size: Int) -> Population
	
	func seeding() -> () -> Chromosome
	
	func fitness(of chromosome: Chromosome) -> Double
	
	func reproduce(population: Population) -> Population
	
}

public protocol FitnessEnvironment {
	
	var tasks: [Task] { get set }
	
	/// The pool of `Task`s in use for fitness evaluation in an evolutionary process.
	var evolutionaryTasks: [Task] { get }
	
	/// The pool of `Task`s in use for fitness evaluation in a post-evolutionary experimental evaluation process.
	var testTasks: [Task] { get }
	
	/// Evaluates the fitness value of a `Chromosome`.
	/// - note: This method can be used as a `FitnessFunc` when `self` is partially applied.
	func evaluateFitness(chromosome: Chromosome) -> Double
	
	/// Evaluates the fitness of all members of a `Population`.
	func evaluateFitness(inout population: Population)
	
	/// Evaluates the fitness value of a `Chromosome`.
	/// - note: This method can be used as a `FitnessFunc` when `self` is partially applied.
	func evaluateFitnessOfChromosome(chromosome: Chromosome) -> Double
	
	func selectEvolutionaryTasks(count: Int)
}

public class Environment: FitnessEnvironment {
	
	/// The pool of `Task`s in use for fitness evaluation in an evolutionary process.
	public var evolutionaryTasks = [Task]()
	
	/// The pool of `Task`s in use for fitness evaluation in a post-evolutionary experimental evaluation process.
	public var testTasks = [Task]()
	
	/// The pool of `Tasks` not in use for fitness evaluation in an evolutionary process.
//	public var nonEvolutionaryTasks: [Task] {
//		return tasks.filter { !self.evolutionaryTasks.contains($0) }
//	}
	
	/// The list of fitness values measured per `Chromosome`, in order of recording.
	public var fitnessHistory = [Chromosome: [Double]]()
	
	/// The number of fitness history measurements to be stored per `Chromosome`.
	public var historyLength: Int = 0
	
	/// The function used to evaluate the fitness of a `Chromosome` on a given `Task`.
//	public var taskFitnessFunc: TaskFitnessFunc
	
	/// The pool of all `Task`s available to the environment.
	public var tasks = [Task]()
	
	/// Constructs a new `Environment` with a `TaskFitnessFunc` and a history length.
//	public init(taskFitnessFunc: TaskFitnessFunc, historyLength: Int = 0) {
//		self.taskFitnessFunc = taskFitnessFunc
//		self.historyLength = historyLength
//	}
	
	let numberOfTrainingEpochs = 10
	
	public func evaluateFitness(chromosome: Chromosome) -> Double {
		return evaluateFitness(chromosome, tasks: evolutionaryTasks)
	}
	
	/// Evaluates the fitness of all members of a `Population`.
	public func evaluateFitness(inout population: Population) {
		
		// Create dispatch queue and group
		let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
		let group = dispatch_group_create()
		
		// 🚦 Prevent concurrent access to fitnessHistory
		let semaphore = dispatch_semaphore_create(1)
		
		// Concurrently evaluate fitness of all individuals
		for member in population {
			dispatch_group_async(group, queue, { () -> Void in
				let chromosome = member.chromosome
				// Just compute fitness if we aren't tracking histories
				guard self.historyLength > 0 else {
					member.fitness = self.evaluateFitness(chromosome)
					return
				}
				
				// 🚦 Retrieve fitness history
				dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
				var fitnessHistory = self.fitnessHistory[chromosome] ?? []
				dispatch_semaphore_signal(semaphore)
				
				// Compute new fitness history entry if history isn't capped
				if fitnessHistory.count < self.historyLength {
					// Compute fitness on evolutionaryTasks
					let fitness = self.evaluateFitness(chromosome, tasks: self.evolutionaryTasks)
					fitnessHistory.append(fitness)
					
					// 🚦 Update the fitness history
					dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
					self.fitnessHistory[chromosome] = fitnessHistory
					dispatch_semaphore_signal(semaphore)
				}
				
				// Compute the historical average fitness
				let fitness = fitnessHistory.reduce(0, combine: +) / Double(fitnessHistory.count)
				member.fitness = fitness
			})
		}
		
		// Wait until all individuals have been evaluated
		dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
	}
	
	/// Evaluates the fitness value of a `Chromosome` by computing the avereapplying the `evolutionaryTasks` to the `taskFitnessFunc` and averaging the results.
	public func evaluateFitnessOfChromosome(chromosome: Chromosome) -> Double {
		/*
		// 🚦 Prevent concurrent access to fitnessHistory
		let semaphore = dispatch_semaphore_create(1)
		
		// 🚦 Retrieve fitness history
		var fitnessHistory = [Double]()
		print("wait")
		dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
		print("critical section")
		fitnessHistory += self.fitnessHistory[chromosome] ?? []
		print("signal")
		dispatch_semaphore_signal(semaphore)
		
		// Compute new fitness history entry if history isn't capped
		if fitnessHistory.count < historyLength {
			
			// Compute fitness on evolutionaryTasks
			let fitness = evaluateFitnessOfChromosome(chromosome, onTasks: evolutionaryTasks)
			fitnessHistory.append(fitness)
			
			// 🚦 Update the fitness history
			print("wait")
			dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
			print("critical section")
			self.fitnessHistory[chromosome] = fitnessHistory
			dispatch_semaphore_signal(semaphore)
			print("signal")
		}
		
		// Compute the historical average fitness
		var fitness = fitnessHistory.reduce(0, combine: +)
		fitness /= Double(fitnessHistory.count)
		*/
		let fitness = evaluateFitness(chromosome, tasks: evolutionaryTasks)
		return fitness
	}
	
	/// Evaluates the fitness of a `Chromosome` on a given `Task`.
	func evaluateFitness(chromosome: Chromosome, task: Task) -> Double {
		
		var network = SingleLayerSingleOutputNeuralNetwork(
			size: task.inputCount + 1,
			activation: sigmoid(λ: 1)) as FeedForwardNeuralNetwork
		
		let learningRule = ChalmersLearningRule(
			bits: chromosome.genes)
		
		learningRule.trainNetwork(&network, task: task, numberOfTimes: numberOfTrainingEpochs)
		
		let error = network.testOnTask(task)
		
		let fitness = 1.0 - (error / Double(task.patterns.count))
		
		return fitness
	}
	
	/// Computes the average fitness of *chromosome* across *tasks* using `taskFitnessFunc`.
	func evaluateFitness(chromosome: Chromosome, tasks: [Task]) -> Double {
		
		var fitness = tasks.reduce(Double(0)) { (sum, task) in
			sum + self.evaluateFitness(chromosome, task: task)
		}
		
		fitness /= Double(tasks.count)
		
		return fitness
	}
	
	///
	public func selectEvolutionaryTasks(count: Int) {
		evolutionaryTasks.removeAll(keepCapacity: true)
		
		let count = min(count, tasks.count)
		var pool = tasks
		
		for _ in 0..<count {
			let index = Int(arc4random_uniform(UInt32(pool.count)))
			evolutionaryTasks.append(pool.removeAtIndex(index))
		}
	}
	
	///
	public func generateTestTasks(count: Int) {
		
//		self.testTasks.removeAll(keepCapacity: true)
		
//		var pool =
	}
	
}