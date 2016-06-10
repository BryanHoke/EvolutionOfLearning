//
//  ExperimentRunner.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/15/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

class ExperimentRunner<IndividualType : Individual> : ExperimentRunning {
	
	typealias Record = AnyTrialRecord<IndividualType>
	
	weak var recorder: ExperimentRecorder<Record>?
	
	var config = ExperimentConfig()
	
	var condition: ExperimentalCondition = .learningRuleEvolution
	
	let allConditions = ExperimentalCondition.allConditions
	
	var numberOfTrials = 10
	
	var numberOfGenerations: Int {
		get { return config.evolutionConfig.numberOfGenerations }
		set { config.evolutionConfig.numberOfGenerations = newValue }
	}
	
	var numberOfTasks: Int {
		get { return config.evolutionaryTaskCount }
		set { config.evolutionaryTaskCount = newValue }
	}
	
	private var configForWriting: ExperimentConfig {
		var config = self.config
		switch condition {
		case .learningRuleEvolution:
			config.fitnessConfig.bitsPerWeight = 0
			config.fitnessConfig.encodingExponentShift = 0
		case .networkEvolution:
			config.fitnessConfig.learningRuleSize = 0
			config.fitnessConfig.numberOfTrainingEpochs = 0
		}
		return config
	}
	
	func runExperiment(using tasks: [Task]) {
		srand48(Int(arc4random()))
		
		recorder?.createResultsDirectory()
		recorder?.write(configForWriting)
		
		let experiment = makeExperiment(tasks: tasks)
		experiment.run(forNumberOfTrials: numberOfTrials, onTrialComplete: {
			[unowned self] (record, index) in
			self.recorder?.write(record, withIndex: index)
		})
		
		recorder?.writeOverview()
	}
	
	
	
	private func makeExperiment(tasks tasks: [Task]) -> AnyExperiment<Record> {
		switch condition {
		case .learningRuleEvolution:
			return AnyExperiment(ChalmersExperiment(tasks: tasks, config: config))
		case .networkEvolution:
			return AnyExperiment(NetworkEvolutionExperiment(tasks: tasks, config: config))
		}
	}
	
}
