//
//  LearningNetworkEvolutionTrial.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/25/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct LearningNetworkEvolutionTrial<IndividualType : Individual> {
	
	public typealias EvolutionRecordType = EvolutionRecord<IndividualType>
	
	public typealias PopulationType = Population<IndividualType>
	
	public typealias ChromosomeType = IndividualType.ChromosomeType
	
	public var evolutionaryTasks: [Task]
	
	public var testTasks: [Task]
	
	public var config: ExperimentConfig
	
	public func run() -> ComposedTrialRecord<IndividualType> {
		var evaluations: [AnyEvaluationRecord<IndividualType>] = []
		evaluations.reserveCapacity(8)
		
		let evolutionRecord = runEvolution()
		evaluations.append(AnyEvaluationRecord(evolutionRecord))
		
		let bestChromosome = findMostFitIndividual(in: evolutionRecord.history).chromosome
		
		for useNurturing in [false, true] {
			let fitnessTestRecord = runFitnessTest(using: bestChromosome, nurturingCondition: useNurturing)
			
			let learningTestRecord = runLearningTest(using: bestChromosome, nurturingCondition: useNurturing)
			
			let generalizationTestRecord = runGeneralizationTest(using: bestChromosome, nurturingCondition: useNurturing)
			
			evaluations += [
				AnyEvaluationRecord(fitnessTestRecord),
				AnyEvaluationRecord(learningTestRecord),
				AnyEvaluationRecord(generalizationTestRecord)
			]
		}
		
		let networkTestRecord = runNetworkTest(using: bestChromosome)
		evaluations.append(AnyEvaluationRecord(networkTestRecord))
		
		return ComposedTrialRecord(evaluations: evaluations)
	}
	
	private func runEvolution() -> EvolutionRecordType {
		let fitness = AnyFitnessAgent<ChromosomeType>(LearningNetworkEvolutionFitnessAgent(config: config.fitnessConfig, tasks: evolutionaryTasks))
		
		let reproduction = AnyReproductionAgent(ChalmersReproductionAgent<IndividualType>(config: config.reproductionConfig))
		
		let environment = EvolutionaryEnvironment(config: config.environmentConfig, fitnessAgent: fitness, reproductionAgent: reproduction)
		
		let evolution = Evolution(config: config.evolutionConfig, environment: environment)
		
		return evolution.run()
	}
	
	private func runFitnessTest(using chromosome: ChromosomeType, nurturingCondition: Bool) -> ChromosomeTestRecord<IndividualType> {
		let fitnessConfig = self.fitnessConfig(forNurturingCondition: nurturingCondition)
		
		let agent = AnyFitnessAgent<ChromosomeType>(LearningNetworkEvolutionFitnessAgent(config: fitnessConfig, tasks: evolutionaryTasks))
		
		let fitness = agent.fitness(of: chromosome)
		let recordPrefix = namePrefix(forNurturingCondition: nurturingCondition)

		let record = ChromosomeTestRecord<IndividualType>(chromosome: chromosome, fitness: fitness, tasks: testTasks, name: "\(recordPrefix) Fitness Test")
		return record
	}
	
	private func runLearningTest(using chromosome: ChromosomeType, nurturingCondition: Bool) -> ChromosomeTestRecord<IndividualType> {
		let fitnessConfig = self.fitnessConfig(forNurturingCondition: nurturingCondition)
		
		let agent = AnyFitnessAgent<ChromosomeType>(LearningRuleEvolutionFitnessAgent(config: fitnessConfig, tasks: evolutionaryTasks))
		
		let fitness = agent.fitness(of: chromosome)
		let recordPrefix = namePrefix(forNurturingCondition: nurturingCondition)
		
		let record = ChromosomeTestRecord<IndividualType>(chromosome: chromosome, fitness: fitness, tasks: testTasks, name: "\(recordPrefix) Learning Test")
		return record
	}
	
	private func runGeneralizationTest(using chromosome: ChromosomeType, nurturingCondition: Bool) -> ChromosomeTestRecord<IndividualType> {
		let fitnessConfig = self.fitnessConfig(forNurturingCondition: nurturingCondition)
		
		let agent = AnyFitnessAgent<ChromosomeType>(LearningRuleEvolutionFitnessAgent(config: fitnessConfig, tasks: testTasks))
		
		let fitness = agent.fitness(of: chromosome)
		let recordPrefix = namePrefix(forNurturingCondition: nurturingCondition)
		
		let record = ChromosomeTestRecord<IndividualType>(chromosome: chromosome, fitness: fitness, tasks: testTasks, name: "\(recordPrefix) Generalization Test")
		return record
	}
	
	private func runNetworkTest(using chromosome: ChromosomeType) -> ChromosomeTestRecord<IndividualType> {
		let agent = AnyFitnessAgent<ChromosomeType>(NetworkEvolutionFitnessAgent(config: config.fitnessConfig, tasks: evolutionaryTasks))
		let fitness = agent.fitness(of: chromosome)
		let record = ChromosomeTestRecord<IndividualType>(chromosome: chromosome, fitness: fitness, tasks: evolutionaryTasks, name: "Network Test")
		return record
	}
	
	private func fitnessConfig(forNurturingCondition nurturingCondition: Bool) -> FitnessConfig {
		var fitnessConfig = config.fitnessConfig
		fitnessConfig.trainingCountsTowardFitness = !nurturingCondition
		return fitnessConfig
	}
	
	private func namePrefix(forNurturingCondition nurturingCondition: Bool) -> String {
		return nurturingCondition ? "Nurturing" : "Non-Nurturing"
	}
}

extension LearningNetworkEvolutionTrial {
	
	/// - note: Assumes that the populations in `history` are sorted by fitness.
	private func findMostFitIndividual(in history: [PopulationType]) -> IndividualType {
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

// MARK: - LearningNetworkEvolutionTrialRecord

public struct LearningNetworkEvolutionTrialRecord<IndividualType : Individual> {
	
	public var evolutionRecord: EvolutionRecord<IndividualType>
	
	public var learningTestRecord: ChromosomeTestRecord<IndividualType>
	
	public var networkTestRecord: ChromosomeTestRecord<IndividualType>
}

extension LearningNetworkEvolutionTrialRecord : TrialRecord {
	
	public var evaluations: [AnyEvaluationRecord<IndividualType>] {
		return [
			AnyEvaluationRecord(evolutionRecord),
			AnyEvaluationRecord(learningTestRecord),
			AnyEvaluationRecord(networkTestRecord)
		]
	}
}

// MARK: -  ChromosomeTestRecord

/// A record of the evaluation of a single chromosome.
public struct ChromosomeTestRecord<IndividualType : Individual> {
	
	/// The chromosome that was evaluated.
	public let chromosome: IndividualType.ChromosomeType
	
	/// The evaluated fitness of the chromosome.
	public let fitness: Double
	
	/// The tasks on which the chromosome was evaluated.
	public let tasks: [Task]
	
	/// The name of the evaluation condition.
	public let name: String
}

extension ChromosomeTestRecord : EvaluationRecord {

	public var populations: [Population<IndividualType>] {
		var individual = IndividualType.init(chromosome: chromosome)
		individual.fitness = fitness
		let population = Population(members: [individual])
		return [population]
	}
}
