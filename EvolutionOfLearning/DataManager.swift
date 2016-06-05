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
	func beginRecordingExperiment(experiment: ExperimentType)
	
	///
	func recordPopulation(population: Population<ExperimentType.Record.IndividualType>)
}