//
//  FitnessAgent.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 11/7/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public protocol FitnessAgent {
	
	var tasks: [Task] { get }
	
	func seed() -> Chromosome
	
	func fitness(of chromosome: Chromosome, on task: Task) -> Double
	
}

extension FitnessAgent {
	
	public func fitness(of chromosome: Chromosome) -> Double {
		let totalFitness = tasks.reduce(0.0) { (total, task) -> Double in
			total + self.fitness(of: chromosome, on: task)
		}
		return totalFitness / Double(tasks.count)
	}
	
	public func fitness(of network: FeedForwardNeuralNetwork, on task: Task) -> Double {
		let error = network.testOnTask(task)
		let meanError = error / Double(task.patterns.count)
		return 1.0 - meanError
	}
	
}
