//
//  ExperimentRunner.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/15/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

class ExperimentRunner : ExperimentRunning {
	
	weak var persister: RecordPersisting?
	
	var config = ExperimentConfig()
	
	var condition: ExperimentalCondition = .learningRuleEvolution
	
	let allConditions = ExperimentalCondition.allConditions
	
	var numberOfTrials = 10
	
	var numberOfGenerations: Int {
		get {
			return config.evolutionConfig.numberOfGenerations
		}
		set {
			config.evolutionConfig.numberOfGenerations = newValue
		}
	}
	
	func runExperiment(using tasks: [Task]) {
		let experiment = makeExperiment(tasks: tasks)
		let record = experiment.run(forNumberOfTrials: numberOfTrials)
		persister?.persist(record)
	}
	
	private func makeExperiment(tasks tasks: [Task]) -> Experiment {
		switch condition {
		case .learningRuleEvolution:
			return ChalmersExperiment(tasks: tasks, config: config)
		}
	}
	
}
