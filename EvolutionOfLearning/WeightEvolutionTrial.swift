//
//  WeightEvolutionTrial.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/26/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct NetworkEvolutionTrial<IndividualType : Individual> {
	
	public typealias EvolutionRecordType = EvolutionRecord<IndividualType>
	
	public typealias PopulationType = Population<IndividualType>
	
	public typealias ChromosomeType = IndividualType.ChromosomeType
	
	public var tasks: [Task]
	
	public var config: ExperimentConfig
	
	public func run() -> NetworkEvolutionTrialRecord<IndividualType> {
		let evolutionRecord = runEvolution()
		return NetworkEvolutionTrialRecord(evolutionRecord: evolutionRecord)
	}
	
	private func runEvolution() -> EvolutionRecord<IndividualType> {
		let fitness = makeFitnessAgent(with: tasks)
		let reproduction = makeReproductionAgent()
		let environment = makeEnvironment(fitness, reproduction: reproduction)
		let evolution = makeEvolution(environment)
		return evolution.run()
	}
	
	private func makeFitnessAgent(with tasks: [Task]) -> AnyFitnessAgent<ChromosomeType> {
		let fitnessConfig = config.fitnessConfig
		return AnyFitnessAgent(NetworkEvolutionFitnessAgent(config: fitnessConfig, tasks: tasks))
	}
	
	private func makeReproductionAgent() -> AnyReproductionAgent<IndividualType> {
		return AnyReproductionAgent(ChalmersReproductionAgent(config: config.reproductionConfig))
	}
	
	private func makeEnvironment(fitness: AnyFitnessAgent<ChromosomeType>, reproduction: AnyReproductionAgent<IndividualType>) -> EvolutionaryEnvironment<IndividualType> {
		return EvolutionaryEnvironment(config: config.environmentConfig, fitnessAgent: fitness, reproductionAgent: reproduction)
	}
	
	private func makeEvolution<EnvironmentType : Environment>(environment: EnvironmentType) -> Evolution<EnvironmentType> {
		return Evolution(config: config.evolutionConfig, environment: environment)
	}
	
}

public struct NetworkEvolutionTrialRecord<IndividualType : Individual> {
	
	public var evolutionRecord: EvolutionRecord<IndividualType>
	
}

extension NetworkEvolutionTrialRecord : TrialRecord {
	
	public var evaluations: [AnyEvaluationRecord<IndividualType>] {
		return [AnyEvaluationRecord(evolutionRecord)]
	}
	
}
