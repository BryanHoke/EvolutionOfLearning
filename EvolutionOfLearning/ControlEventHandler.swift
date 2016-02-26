//
//  ControlEventHandler.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 2/24/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

protocol ControlEventHandler {
	
	func numberOfGenerationsChanged(to value: Int)
	
	func numberOfTrialsChanged(to value: Int)
	
	func runButtonClicked()
	
}