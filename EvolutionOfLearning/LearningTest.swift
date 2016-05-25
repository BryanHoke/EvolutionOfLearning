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
		print("LearningTest")
		let mostFitIndividual = findMostFitIndividual()
		let chromosome = mostFitIndividual.chromosome
		let fitness = fitnessAgent.fitness(of: chromosome)
		print(fitness)
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
	
	public let chromosome: Chromosome
	
	public let fitness: Double
	
	public let tasks: [Task]
	
}

extension LearningTestRecord : EvaluationRecord {
	
	public var name: String { return "Learning Test" }
	
	public var populations: [Population] {
		var individual = Individual(chromosome: chromosome)
		individual.fitness = fitness
		let population = Population(members: [individual])
		return [population]
	}
	
}
