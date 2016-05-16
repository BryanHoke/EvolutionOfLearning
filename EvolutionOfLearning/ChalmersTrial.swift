//
//  ChalmersTrial.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/11/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public typealias FitnessAgentFactory = (tasks: [Task]) -> FitnessAgent

public struct ChalmersTrial {
	
	public var evolutionaryTasks: [Task]
	
	public var testTasks: [Task]
	
	public var config: ExperimentConfig
	
	public func run() -> ChalmersTrialRecord {
		let evolutionRecord = runEvolution()
		
		let testRecord = runLearningTest(with: evolutionRecord.history)
		
		return ChalmersTrialRecord(evolutionRecord: evolutionRecord, learningTestRecord: testRecord)
	}
	
	private func runEvolution() -> EvolutionRecord {
		let fitness = makeFitnessAgent(with: evolutionaryTasks)
		let reproduction = makeReproductionAgent()
		let environment = makeEnvironment(fitness, reproduction: reproduction)
		let evolution = makeEvolution(environment)
		return evolution.run()
	}
	
	private func runLearningTest(with history: [Population]) -> LearningTestRecord {
		let fitness = makeFitnessAgent(with: testTasks)
		let learningTest = LearningTest(fitnessAgent: fitness, history: history)
		return learningTest.run()
	}
	
	private func makeFitnessAgent(with tasks: [Task]) -> FitnessAgent {
		return LearningRuleEvolutionFitnessAgent(config: config.fitnessConfig, tasks: tasks)
	}
	
	private func makeReproductionAgent() -> ReproductionAgent {
		return ChalmersReproductionAgent(config: config.reproductionConfig)
	}
	
	private func makeEnvironment(fitness: FitnessAgent, reproduction: ReproductionAgent) -> EvolutionaryEnvironment {
		return Environment(config: config.environmentConfig, fitnessAgent: fitness, reproductionAgent: reproduction)
	}
	
	private func makeEvolution(environment: EvolutionaryEnvironment) -> Evolution {
		return Evolution(config: config.evolutionConfig, environment: environment)
	}
	
}

public struct ChalmersTrialRecord {
	
	public var evolutionRecord: EvolutionRecord
	
	public var learningTestRecord: LearningTestRecord
	
}

extension ChalmersTrialRecord : TrialRecord {
	
	public var evaluations: [EvaluationRecord] {
		return [evolutionRecord, learningTestRecord]
	}
	
}
