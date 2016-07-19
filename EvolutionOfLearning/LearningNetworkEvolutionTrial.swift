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
