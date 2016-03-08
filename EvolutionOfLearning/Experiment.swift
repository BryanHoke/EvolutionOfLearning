//
//  Experiment.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/19/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

// MARK: - ExperimentType Protocol

public protocol ExperimentType {
	
	
}

// MARK: - Experiment Output Protocol

protocol ExperimentOutput {
	
	func experimentDidBeginNewTrial(experiment: Experiment)
	
	func experiment(experiment: Experiment,
		didEvaluatePopulation pop: Population)
	
	func experimentDidComplete(experiment: Experiment)
}

// MARK: - Experiment

public class Experiment {
	
	// MARK: - Instance Properties
	
	/// The file path from which the `environment` should be loaded at the start of the experiment.
	var environmentPath: String?
	
	let chromosomeSize = 35
	
	let populationSize = 40
	
	let elitismCount = 1
	
	let crossoverRate = 0.8
	
	let mutationRate = 0.01
	
	let numberOfTrainingEpochs = 10
	
	var taskCount = 30
	
	var numberOfGenerations: Int = 0
	
	var numberOfTrials: Int = 0
	
	var output: ExperimentOutput?
	
}