//
//  LearningTest.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/8/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct LearningTest {
	
	public var fitnessAgent: FitnessAgent
	
	public var history: [Population]
	
	func run() -> LearningTestRecord {
		let mostFitIndividual = findMostFitIndividual()
		let chromosome = mostFitIndividual.chromosome
		let fitness = fitnessAgent.fitness(of: chromosome)
		return LearningTestRecord(chromosome: chromosome, fitness: fitness, tasks: fitnessAgent.tasks)
	}
	
	/// - note: Assumes `Population`s in `history` are sorted by `fitness`.
	public func findMostFitIndividual() -> Individual {
		guard !history.isEmpty else {
			preconditionFailure("History must not be empty")
		}
		var mostFitIndividual: Individual?
		for population in history {
			guard let mostFitMember = population.first else {
				preconditionFailure("No population should be empty")
			}
			guard let currentMostFitIndividual = mostFitIndividual else {
				mostFitIndividual = mostFitMember
				continue
			}
			if mostFitMember.fitness > currentMostFitIndividual.fitness {
				mostFitIndividual = mostFitMember
			}
		}
		return mostFitIndividual!
	}
	
}

public struct LearningTestRecord {
	
	let chromosome: Chromosome
	
	let fitness: Double
	
	let tasks: [Task]
	
}
