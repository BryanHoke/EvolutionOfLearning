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
	
//	func run(forNumberOfTrials numberOfTrials: Int) -> ExperimentRecord
	
	func run(forNumberOfTrials numberOfTrials: Int, onTrialComplete: (TrialRecord, Int) -> Void)
	
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

struct ExperimentOverview {
	
	var averageFitnessesPerEvaluation: [String: [[Double]]] = [:]
	
	var maximumFitnessesPerEvaluation: [String: [[Double]]] = [:]
	
	var keyOrder: [String] = []
	
	var meanAverageFitnesses: [[Double]] {
		var means = [[Double]]()
		
		for key in keyOrder {
			guard let averages = averageFitnessesPerEvaluation[key] else {
				continue
			}
			means.append(self.means(ofValues: averages))
		}
		
		return means
	}
	
	var meanMaximumFitnesses: [[Double]] {
		var means = [[Double]]()
		
		for key in keyOrder {
			guard let maximums = maximumFitnessesPerEvaluation[key] else {
				continue
			}
			means.append(self.means(ofValues: maximums))
		}
		
		return means
	}
	
	func means(ofValues values: [[Double]]) -> [Double] {
		var means = [Double]()
		let count = values.first?.count ?? 0
		means.reserveCapacity(count)
		let divisor = Double(values.count)
		
		for i in 0..<count {
			let sum = values.reduce(0) { $0 + $1[i] }
			let mean = sum / divisor
			means.append(mean)
		}
		
		return means
	}
	
	mutating func accumulate(trial: TrialRecord) {
		for evaluation in trial.evaluations {
			accumulate(evaluation)
		}
	}
	
	mutating func accumulate(evaluation: EvaluationRecord) {
		let key = evaluation.name
		
		if !keyOrder.contains(key) {
			keyOrder.append(key)
			averageFitnessesPerEvaluation[key] = []
			maximumFitnessesPerEvaluation[key] = []
		}
		
		let averages = evaluation.populations.map { $0.averageFitness }
		averageFitnessesPerEvaluation[key]!.append(averages)
		
		let maximums = evaluation.populations.map { $0[0].fitness }
		maximumFitnessesPerEvaluation[key]!.append(maximums)
	}
	
}
