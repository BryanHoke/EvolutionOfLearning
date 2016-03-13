//
//  LearningTest.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/8/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation



public struct LearningTest {
	
	let fitnessAgent: FitnessAgent
	
	let fetcher: DataFetcher
	
	func computeTestFitness() -> LearningTestRecord {
		let chromosome = fetcher.fetchMostFitChromosome()
		let fitness = fitnessAgent.fitness(of: chromosome)
		return LearningTestRecord(chromosome: chromosome, fitness: fitness, tasks: fitnessAgent.tasks)
	}
	
}

public struct LearningTestRecord {
	
	let chromosome: Chromosome
	
	let fitness: Double
	
	let tasks: [Task]
	
}
