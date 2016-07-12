//
//  ExperimentDriver.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/8/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

class ExperimentDriver<IndividualType : Individual> {

	typealias Record = AnyTrialRecord<IndividualType>
	
	weak var recorder: ExperimentRecorder<Record>?
	
	var config = ExperimentConfig()
	
	var condition = ExperimentalCondition.learningRuleEvolution
	
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
	
	var fitnessIncludesTraining: Bool {
		get { return config.fitnessConfig.trainingCountsTowardFitness }
		set { config.fitnessConfig.trainingCountsTowardFitness = newValue }
	}
	
	var selectedConditionName: String {
		return condition.name
	}
	
	var allConditionNames: [String] {
		return allConditions.map { $0.name }
	}
	
	var selectedConditionIndex: Int? {
		get {
			return allConditions.indexOf(condition)
		}
		set {
			guard let index = newValue else {
				return
			}
			condition = allConditions[index]
		}
	}
	
	let numberOfTasksUpperBound = 20
	
	var maxNumberOfTasks = 20
	
	var environmentPath: String {
		return "/Users/bryanhoke/Projects/BDHSoftware/OS X/EvolutionOfLearning/Resources/Environment1.txt"
	}
	
	weak var interface: ExperimentInterface? {
		didSet {
			syncInterface()
		}
	}
	
	private func syncInterface() {
		guard let interface = self.interface else { return }

		interface.experimentalConditions = allConditionNames
		interface.selectedConditionIndex = selectedConditionIndex
		interface.numberOfTrials = numberOfTrials
		interface.numberOfGenerations = numberOfGenerations
		interface.numberOfTasks = numberOfTasks
		interface.maxNumberOfTasks = maxNumberOfTasks
		interface.numberOfTasksUpperBound = numberOfTasksUpperBound
		interface.fitnessIncludesTraining = fitnessIncludesTraining
	}
	
	func runExperiments() {
		let tasks = loadTasks()
		var config = self.config
		
		for n in numberOfTasks...maxNumberOfTasks {
			config.evolutionaryTaskCount = n
			runExperiment(using: tasks, with: config)
		}
	}
	
	func runExperiment(using tasks: [Task], with config: ExperimentConfig) {
		srand48(Int(arc4random()))
		
		recorder?.createResultsDirectory()
		recorder?.write(makeConfigForWriting(from: config))
		
		let experiment = makeExperiment(tasks: tasks, config: config)
		experiment.run(forNumberOfTrials: numberOfTrials, onTrialComplete: {
			[unowned self] (record, index) in
			self.recorder?.write(record, withIndex: index)
			})
		
		recorder?.writeOverview()
	}
	
	private func makeConfigForWriting(from original: ExperimentConfig) -> ExperimentConfig {
		var config = original
		switch condition {
		case .learningRuleEvolution:
			config.fitnessConfig.usesLearningRuleEvolution = true
			config.fitnessConfig.usesNetworkEvolution = false
		case .networkEvolution:
			config.fitnessConfig.usesLearningRuleEvolution = false
			config.fitnessConfig.usesNetworkEvolution = true
		case .learningNetworkEvolution:
			config.fitnessConfig.usesLearningRuleEvolution = true
			config.fitnessConfig.usesNetworkEvolution = true
		}
		return config
	}
	
	private func makeExperiment(tasks tasks: [Task], config: ExperimentConfig) -> AnyExperiment<Record> {
		switch condition {
		case .learningRuleEvolution:
			return AnyExperiment(ChalmersExperiment(tasks: tasks, config: config))
		case .networkEvolution:
			return AnyExperiment(NetworkEvolutionExperiment(tasks: tasks, config: config))
		case .learningNetworkEvolution:
			return AnyExperiment(LearningNetworkEvolutionExperiment(tasks: tasks, config: config))
		}
	}
}

// MARK: - ConfigurationEventHandling

extension ExperimentDriver : ConfigurationEventHandling {
	
	func selectedConditionIndexChanged(to index: Int) {
		self.selectedConditionIndex = index
	}
	
	func numberOfGenerationsChanged(to numberOfGenerations: Int) {
		self.numberOfGenerations = numberOfGenerations
	}
	
	func numberOfTrialsChanged(to numberOfTrials: Int) {
		self.numberOfTrials = numberOfTrials
	}
	
	func numberOfTasksChanged(to numberOfTasks: Int) {
		self.numberOfTasks = numberOfTasks
	}
	
	func maxNumberOfTasksChanged(to maxNumberOfTasks: Int) {
		self.maxNumberOfTasks = maxNumberOfTasks
	}
	
	func fitnessIncludesTrainingChanged(to newValue: Bool) {
		fitnessIncludesTraining = newValue
	}
	
	func runButtonPressed() {
		runExperiments()
	}
	
	private func loadTasks() -> [Task] {
		let parser = TaskParser()
		do {
			return try parser.tasks(withFileAt: environmentPath)
		}
		catch let error as NSError {
			print(error)
			return []
		}
	}
}
