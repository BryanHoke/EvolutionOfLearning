//
//  Environment.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/19/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public typealias TaskFitnessFunc = (Chromosome, Task) -> Double

public protocol FitnessEnvironment {
	
	/// Evaluates the fitness value of a `Chromosome`.
	/// - note: This method can be used as a `FitnessFunc` when `self` is partially applied.
	func evaluateFitnessOfChromosome(chromosome: Chromosome) -> Double
	
}

public final class ChalmersEnvironment: FitnessEnvironment {
	
	/// The pool of `Tasks` in use for fitness evaluation in an evolutionary process.
	public var evolutionaryTasks = [Task]()
	
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
	
	/// Evaluates the fitness value of a `Chromosome` by applying the `taskFitnessFunc` to the `evolutionaryTasks` and averaging the results.
	public func evaluateFitnessOfChromosome(chromosome: Chromosome) -> Double {
		let semaphore = dispatch_semaphore_create(1)
		
		var fitnessHistory = [Double]()
		dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
		fitnessHistory += self.fitnessHistory[chromosome] ?? []
		dispatch_semaphore_signal(semaphore)
		
		return 0
	}
	
}