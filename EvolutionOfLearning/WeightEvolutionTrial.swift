//
//  WeightEvolutionTrial.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/26/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct NetworkEvolutionTrial {
	
	public var tasks: [Task]
	
	public var config: ExperimentConfig
	
	public func run() -> NetworkEvolutionTrialRecord {
		let evolutionRecord = runEvolution()
		return NetworkEvolutionTrialRecord(evolutionRecord: evolutionRecord)
	}
	
	private func runEvolution() -> EvolutionRecord {
		let fitness = makeFitnessAgent(with: tasks)
		let reproduction = makeReproductionAgent()
		let environment = makeEnvironment(fitness, reproduction: reproduction)
		let evolution = makeEvolution(environment)
		return evolution.run()
	}
	
	private func makeFitnessAgent(with tasks: [Task]) -> FitnessAgent {
		let fitnessConfig = config.fitnessConfig
		return NetworkEvolutionFitnessAgent(bitsPerWeight: fitnessConfig.bitsPerWeight, exponentShift: fitnessConfig.encodingExponentShift, tasks: tasks)
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

public struct NetworkEvolutionTrialRecord {
	
	public var evolutionRecord: EvolutionRecord
	
}

extension NetworkEvolutionTrialRecord : TrialRecord {
	
	public var evaluations: [EvaluationRecord] {
		return [evolutionRecord]
	}
	
}
