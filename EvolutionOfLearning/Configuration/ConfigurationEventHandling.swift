//
//  ConfigurationEventHandling.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/3/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

protocol ConfigurationEventHandling: class {
	
	func selectedConditionIndexChanged(to index: Int)
	
	func numberOfGenerationsChanged(to numberOfGenerations: Int)
	
	func numberOfTrialsChanged(to numberOfTrials: Int)
	
	func numberOfTasksChanged(to numberOfTasks: Int)
	
	func maxNumberOfTasksChanged(to maxNumberOfTasks: Int)
	
	func fitnessIncludesTrainingChanged(to newValue: Bool)
	
	func runButtonPressed()
	
}
