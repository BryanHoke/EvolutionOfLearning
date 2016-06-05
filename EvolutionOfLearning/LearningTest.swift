//
//  LearningTest.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/8/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct LearningTest<IndividualType : Individual> {
	
	public typealias PopulationType = Population<IndividualType>
	
	public typealias ChromosomeType = IndividualType.ChromosomeType
	
	public var fitnessAgent: AnyFitnessAgent<ChromosomeType>
	
	public var history: [PopulationType]
	
	func run() -> LearningTestRecord<IndividualType> {
		print("LearningTest")
		let mostFitIndividual = findMostFitIndividual()
		let chromosome = mostFitIndividual.chromosome
		let fitness = fitnessAgent.fitness(of: chromosome)
		print(fitness)
		return LearningTestRecord(chromosome: chromosome, fitness: fitness, tasks: fitnessAgent.tasks)
	}
	
	/// - note: Assumes `Population`s in `history` are sorted by `fitness`.
	public func findMostFitIndividual() -> IndividualType {
		guard !history.isEmpty else {
			preconditionFailure("History must not be empty")
		}
		var mostFitIndividual: IndividualType?
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

public struct LearningTestRecord<IndividualType : Individual> {
	
	public let chromosome: IndividualType.ChromosomeType
	
	public let fitness: Double
	
	public let tasks: [Task]
	
}

extension LearningTestRecord : EvaluationRecord {
	
	public var name: String { return "Learning Test" }
	
	public var populations: [Population<IndividualType>] {
		var individual = IndividualType.init(chromosome: chromosome)
		individual.fitness = fitness
		let population = Population(members: [individual])
		return [population]
	}
	
}
