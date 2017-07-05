//
//  ChalmersTrial.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/11/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public typealias FitnessAgentFactory = (_ tasks: [Task]) -> FitnessAgent

public struct ChalmersTrial<IndividualType : Individual> {
	
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
	
	fileprivate func runEvolution() -> EvolutionRecordType {
		let fitness = makeFitnessAgent(with: evolutionaryTasks)
		let reproduction = makeReproductionAgent()
		let environment = makeEnvironment(fitness, reproduction: reproduction)
		let evolution = makeEvolution(environment)
		return evolution.run()
	}
	
	fileprivate func runLearningTest(with history: [PopulationType]) -> LearningTestRecord<IndividualType> {
		let fitness = makeFitnessAgent(with: testTasks)
		let learningTest = LearningTest(fitnessAgent: fitness, history: history)
		return learningTest.run()
	}
	
	fileprivate func makeFitnessAgent(with tasks: [Task]) -> AnyFitnessAgent<ChromosomeType> {
		return AnyFitnessAgent(LearningRuleEvolutionFitnessAgent(config: config.fitnessConfig, tasks: tasks))
	}
	
	fileprivate func makeReproductionAgent() -> AnyReproductionAgent<IndividualType> {
		return AnyReproductionAgent(ChalmersReproductionAgent<IndividualType>(config: config.reproductionConfig))
	}
	
	fileprivate func makeEnvironment(_ fitness: AnyFitnessAgent<ChromosomeType>, reproduction: AnyReproductionAgent<IndividualType>) -> EvolutionaryEnvironment<IndividualType> {
		return EvolutionaryEnvironment(config: config.environmentConfig, fitnessAgent: fitness, reproductionAgent: reproduction)
	}
	
	fileprivate func makeEvolution<EnvironmentType : Environment>(_ environment: EnvironmentType) -> Evolution<EnvironmentType> {
		return Evolution(config: config.evolutionConfig, environment: environment)
	}
	
}

public struct ChalmersTrialRecord<IndividualType : Individual> {
	
	public var evolutionRecord: EvolutionRecord<IndividualType>
	
	public var learningTestRecord: LearningTestRecord<IndividualType>
	
}

extension ChalmersTrialRecord : TrialRecord {
	
	public var evaluations: [AnyEvaluationRecord<IndividualType>] {
		return [
			AnyEvaluationRecord(evolutionRecord),
			AnyEvaluationRecord(learningTestRecord)
		]
	}
	
}
