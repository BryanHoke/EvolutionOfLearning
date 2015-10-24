//
//  ExperimentOutput.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 10/24/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

protocol ExperimentOutput {
	
	func experimentDidBeginNewTrial(experiment: Experiment)
	
	func experiment(experiment: Experiment,
		didEvaluatePopulation pop: Population)
}