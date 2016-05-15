//
//  ExperimentDriver.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/8/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

class ExperimentDriver : ConfigurationEventHandling {
	
	var config = ExperimentConfig()
	
	var condition: ExperimentalCondition = .learningRuleEvolution
	
	let allConditions = ExperimentalCondition.allConditions
	
	var numberOfTrials = 10
	
	weak var interface: ExperimentInterface? {
		didSet {
			guard let interface = self.interface else {
				return
			}
			interface.experimentalConditions = allConditions.map { $0.name }
			interface.selectedConditionIndex = allConditions.indexOf(condition)
			interface.numberOfTrials = numberOfTrials
			interface.numberOfGenerations = config.evolutionConfig.numberOfGenerations
		}
	}
	
	func selectedConditionIndexChanged(to index: Int) {
		guard let newCondition = ExperimentalCondition(rawValue: index) else {
			return
		}
		self.condition = newCondition
	}
	
	func numberOfGenerationsChanged(to numberOfGenerations: Int) {
		config.evolutionConfig.numberOfGenerations = numberOfGenerations
	}
	
	func numberOfTrialsChanged(to numberOfTrials: Int) {
		self.numberOfTrials = numberOfTrials
	}
	
	func runButtonPressed() {
		
	}
	
}
