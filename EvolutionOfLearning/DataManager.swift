//
//  DataManager.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/20/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation


///
public protocol DataManager : class {
	
	associatedtype ExperimentType : Experiment
	
	///
	func beginNewTrial()
	
	///
	func beginRecordingExperiment(_ experiment: ExperimentType)
	
	///
	func recordPopulation(_ population: Population<ExperimentType.Record.IndividualType>)
}
