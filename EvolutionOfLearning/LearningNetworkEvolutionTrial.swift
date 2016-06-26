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
		let fitness = makeEvolutionFitnessAgent(with: evolutionaryTasks)
		let reproduction = makeReproductionAgent()
		let environment = makeEnvironment(fitness, reproduction: reproduction)
		let evolution = makeEvolution(environment)
		return evolution.run()
	}
	
	private func runLearningTest(with history: [PopulationType]) -> LearningTestRecord<IndividualType> {
		let fitness = makeLearningTestFitnessAgent(with: testTasks)
		let learningTest = LearningTest(fitnessAgent: fitness, history: history)
		return learningTest.run()
	}
	
	private func makeEvolutionFitnessAgent(with tasks: [Task]) -> AnyFitnessAgent<ChromosomeType> {
		return AnyFitnessAgent(LearningNetworkEvolutionFitnessAgent(config: config.fitnessConfig, tasks: tasks))
	}
	
	private func makeLearningTestFitnessAgent(with tasks: [Task]) -> AnyFitnessAgent<ChromosomeType> {
		return AnyFitnessAgent(LearningRuleEvolutionFitnessAgent(config: config.fitnessConfig, tasks: tasks))
	}
	
	private func makeReproductionAgent() -> AnyReproductionAgent<IndividualType> {
		return AnyReproductionAgent(ChalmersReproductionAgent<IndividualType>(config: config.reproductionConfig))
	}
	
	private func makeEnvironment(fitness: AnyFitnessAgent<ChromosomeType>, reproduction: AnyReproductionAgent<IndividualType>) -> EvolutionaryEnvironment<IndividualType> {
		return EvolutionaryEnvironment(config: config.environmentConfig, fitnessAgent: fitness, reproductionAgent: reproduction)
	}
	
	private func makeEvolution<EnvironmentType : Environment>(environment: EnvironmentType) -> Evolution<EnvironmentType> {
		return Evolution(config: config.evolutionConfig, environment: environment)
	}
	
}

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
