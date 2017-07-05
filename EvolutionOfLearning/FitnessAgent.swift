//
//  FitnessAgent.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 11/7/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public protocol FitnessAgent {
	
	associatedtype ChromosomeType : Chromosome
	
	var tasks: [Task] { get }
	
	func seed() -> ChromosomeType
	
	func fitness(of chromosome: ChromosomeType, on task: Task) -> Double
	
}

extension FitnessAgent {
	
	public func fitness(of chromosome: ChromosomeType) -> Double {
		let totalFitness = tasks.reduce(0.0) { (total, task) -> Double in
			total + self.fitness(of: chromosome, on: task)
		}
		return totalFitness / Double(tasks.count)
	}
	
	public func accuracy(of network: FeedForwardNeuralNetwork, on task: Task) -> Double {
		let error = network.testOnTask(task)
		let meanError = error / Double(task.patterns.count)
		return 1.0 - meanError
	}
	
}

public struct AnyFitnessAgent<ChromosomeType : Chromosome> : FitnessAgent {
	
	public let tasks: [Task]
	
	fileprivate let _seed: () -> ChromosomeType
	
	fileprivate let _fitness: (ChromosomeType, Task) -> Double
	
	public init<Agent : FitnessAgent>(_ agent: Agent) where Agent.ChromosomeType == ChromosomeType {
		tasks = agent.tasks
		_seed = agent.seed
		_fitness = agent.fitness(of:on:)
	}
	
	public func seed() -> ChromosomeType {
		return _seed()
	}
	
	public func fitness(of chromosome: ChromosomeType, on task: Task) -> Double {
		return _fitness(chromosome, task)
	}
	
}
