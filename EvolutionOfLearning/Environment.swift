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

public protocol FitnessEnvironment {
	
	/// Evaluates the fitness value of a `Chromosome`.
	/// - note: This method can be used as a `FitnessFunc` when `self` is partially applied.
	func evaluateFitnessOfChromosome(chromosome: Chromosome) -> Double
	
}

public final class ChalmersEnvironment: FitnessEnvironment {
	
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
	public var historyLength: Int
	
	/// The function used to evaluate the fitness of a `Chromosome` on a given `Task`.
	public var taskFitnessFunc: TaskFitnessFunc
	
	/// The pool of all `Task`s available to the environment.
	public var tasks = [Task]()
	
	/// Constructs a new `Environment` with a `TaskFitnessFunc` and a history length.
	public init(taskFitnessFunc: TaskFitnessFunc, historyLength: Int = 0) {
		self.taskFitnessFunc = taskFitnessFunc
		self.historyLength = historyLength
	}
	
	/// Evaluates the fitness value of a `Chromosome` by computing the avereapplying the `evolutionaryTasks` to the `taskFitnessFunc` and averaging the results.
	public func evaluateFitnessOfChromosome(chromosome: Chromosome) -> Double {
		
		// 🚦 Prevent concurrent access to fitnessHistory
		let semaphore = dispatch_semaphore_create(1)
		
		// 🚦 Retrieve fitness history
		var fitnessHistory = [Double]()
		dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
		fitnessHistory += self.fitnessHistory[chromosome] ?? []
		dispatch_semaphore_signal(semaphore)
		
		// Compute new fitness history entry if history isn't capped
		if fitnessHistory.count < historyLength {
			
			// Compute fitness on evolutionaryTasks
			let fitness = evaluateFitnessOfChromosome(chromosome, onTasks: evolutionaryTasks)
			fitnessHistory.append(fitness)
			
			// 🚦 Update the fitness history
			dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
			self.fitnessHistory[chromosome] = fitnessHistory
			dispatch_semaphore_signal(semaphore)
		}
		
		// Compute the historical average fitness
		var fitness = fitnessHistory.reduce(0, combine: +)
		fitness /= Double(fitnessHistory.count)
		
		return fitness
	}
	
	/// Computes the average fitness of *chromosome* across *tasks* using `taskFitnessFunc`.
	func evaluateFitnessOfChromosome(chromsome: Chromosome, onTasks tasks: [Task]) -> Double {
		
		var fitness = tasks.reduce(Double(0)) { (sum, task) in
			sum + self.taskFitnessFunc(chromsome, task)
		}
		
		fitness /= Double(tasks.count)
		
		return fitness
	}
	
	public func generateEvolutionaryTasks(count: Int) {
		
		evolutionaryTasks.removeAll(keepCapacity: true)
		
		let count = min(count, tasks.count)
		var pool = tasks
		
		for _ in 0..<count {

			let index = Int(arc4random_uniform(UInt32(pool.count)))
			evolutionaryTasks.append(pool.removeAtIndex(index))
		}
	}
	
	public func generateTestTasks(count: Int) {
		
		self.testTasks.removeAll(keepCapacity: true)
		
//		var pool =
	}
	
}