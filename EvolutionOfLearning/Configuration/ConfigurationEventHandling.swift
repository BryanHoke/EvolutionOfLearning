//
//  ConfigurationEventHandling.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/3/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

protocol ConfigurationEventHandling: class {
	
	func selectedConditionChanged(to condition: String)
	
	func numberOfGenerationsChanged(to numberOfGenerations: Int)
	
	func numberOfTrialsChanged(to numberOfTrials: Int)
	
	func runButtonPressed()
	
}
