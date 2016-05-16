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

public protocol Experiment {
	
	var config: ExperimentConfig { get set }
	
	func run(forNumberOfTrials numberOfTrials: Int) -> ExperimentRecord
	
}

public protocol ExperimentRecord {
	
	var config: ExperimentConfig { get }
	
	var trials: [TrialRecord] { get }
	
}

public protocol TrialRecord {
	
	var evaluations: [EvaluationRecord] { get }
	
}

public protocol EvaluationRecord {
	
	var name: String { get }
	
	var populations: [Population] { get }
	
	var tasks: [Task] { get }
	
}
