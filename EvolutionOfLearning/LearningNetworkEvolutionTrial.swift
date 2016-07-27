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
	
	public func run() -> ChalmersTrialRecord<IndividualType> {
		let evolutionRecord = runEvolution()
		
		let testRecord = runLearningTest(with: evolutionRecord.history)
		
		return ChalmersTrialRecord(evolutionRecord: evolutionRecord, learningTestRecord: testRecord)
	}
	
	private func runEvolution() -> EvolutionRecordType {
		let fitness = AnyFitnessAgent<ChromosomeType>(LearningNetworkEvolutionFitnessAgent(config: config.fitnessConfig, tasks: evolutionaryTasks))
		
		let reproduction = AnyReproductionAgent(ChalmersReproductionAgent<IndividualType>(config: config.reproductionConfig))
		
		let environment = EvolutionaryEnvironment(config: config.environmentConfig, fitnessAgent: fitness, reproductionAgent: reproduction)
		
		let evolution = Evolution(config: config.evolutionConfig, environment: environment)
		
		return evolution.run()
	}
	
	private func runLearningTest(with history: [PopulationType]) -> LearningTestRecord<IndividualType> {
		let fitness = AnyFitnessAgent<ChromosomeType>(LearningRuleEvolutionFitnessAgent(config: config.fitnessConfig, tasks: testTasks))
		
		let learningTest = LearningTest(fitnessAgent: fitness, history: history)
		
		return learningTest.run()
	}
}

// MARK: - LearningNetworkEvolutionTrialRecord

public struct LearningNetworkEvolutionTrialRecord<IndividualType : Individual> {
	
	public var evolutionRecord: EvolutionRecord<IndividualType>
	
	public var learningTestRecord: LearningTestRecord<IndividualType>
	
}

extension LearningNetworkEvolutionTrialRecord : TrialRecord {
	
	public var evaluations: [AnyEvaluationRecord<IndividualType>] {
		return [
			AnyEvaluationRecord(evolutionRecord),
			AnyEvaluationRecord(learningTestRecord)
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
