//
//  LearningTest.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/8/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct LearningTestResult {
	
	let chromosome: Chromosome
	
	let tasks: [Task]
	
	let fitness: Double
	
}

public struct LearningTest {
	
	let fitnessAgent: FitnessAgent
	
	let fetcher: DataFetcher
	
	func computeTestFitness() -> LearningTestResult {
		let chromosome = fetcher.fetchMostFitChromosome()
		let fitness = fitnessAgent.fitness(of: chromosome)
		return LearningTestResult(chromosome: chromosome, tasks: fitnessAgent.tasks, fitness: fitness)
	}
	
}
