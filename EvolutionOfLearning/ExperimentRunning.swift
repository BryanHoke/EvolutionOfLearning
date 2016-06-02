//
//  ExperimentRunning.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/15/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

protocol ExperimentRunning {
	
	var condition: ExperimentalCondition { get set }
	
	var allConditions: [ExperimentalCondition] { get }
	
	var numberOfTrials: Int { get set }
	
	var numberOfGenerations: Int { get set }
	
	var numberOfTasks: Int { get set }
	
	func runExperiment(using tasks: [Task])
	
}
