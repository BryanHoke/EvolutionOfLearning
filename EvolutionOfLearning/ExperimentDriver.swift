//
//  ExperimentDriver.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/8/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

class ExperimentDriver : ConfigurationEventHandling {
	
	init(experimentRunner: ExperimentRunning) {
		self.experimentRunner = experimentRunner
	}
	
	var experimentRunner: ExperimentRunning
	
	var selectedConditionName: String {
		return experimentRunner.condition.name
	}
	
	var allConditionNames: [String] {
		return experimentRunner.allConditions.map { $0.name }
	}
	
	var selectedConditionIndex: Int? {
		get {
			return experimentRunner.allConditions.indexOf(experimentRunner.condition)
		}
		set {
			guard let index = newValue else {
				return
			}
			experimentRunner.condition = experimentRunner.allConditions[index]
		}
	}
	
	var numberOfTrials: Int {
		get {
			return experimentRunner.numberOfTrials
		}
		set {
			experimentRunner.numberOfTrials = newValue
		}
	}
	
	var numberOfGenerations: Int {
		get {
			return experimentRunner.numberOfGenerations
		}
		set {
			experimentRunner.numberOfGenerations = newValue
		}
	}
	
	weak var interface: ExperimentInterface? {
		didSet {
			syncInterface()
		}
	}
	
	private func syncInterface() {
		guard let interface = self.interface else {
			return
		}
		interface.experimentalConditions = allConditionNames
		interface.selectedConditionIndex = selectedConditionIndex
		interface.numberOfTrials = numberOfTrials
		interface.numberOfGenerations = numberOfGenerations
	}
	
	// MARK: - ConfigurationEventHandling
	
	func selectedConditionIndexChanged(to index: Int) {
		self.selectedConditionIndex = index
	}
	
	func numberOfGenerationsChanged(to numberOfGenerations: Int) {
		self.numberOfGenerations = numberOfGenerations
	}
	
	func numberOfTrialsChanged(to numberOfTrials: Int) {
		self.numberOfTrials = numberOfTrials
	}
	
	func runButtonPressed() {
		experimentRunner.runExperiment()
	}
	
}
