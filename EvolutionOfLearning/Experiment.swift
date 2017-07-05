//
//  Experiment.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/19/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

// MARK: - Experiment Output Protocol

//protocol ExperimentOutput {
//	
//	associatedtype IndividualType : Individual
//	
//	func experimentDidBeginNewTrial(experiment: Experiment)
//	
//	func experiment(experiment: Experiment,
//		didEvaluatePopulation pop: Population<IndividualType>)
//	
//	func experimentDidComplete(experiment: Experiment)
//}

// MARK: - Experiment

public protocol Experiment {
	
	associatedtype Record : TrialRecord
	
	var config: ExperimentConfig { get set }
	
	func run(forNumberOfTrials numberOfTrials: Int, onTrialComplete: (Record, Int) -> Void)
	
}

public struct AnyExperiment<Record : TrialRecord> : Experiment {
	
	public var config: ExperimentConfig
	
	fileprivate let _run: (_ numberOfTrials: Int, _ onTrialComplete: (Record, Int) -> Void) -> Void
	
	public init<ExperimentType : Experiment>(_ experiment: ExperimentType) where ExperimentType.Record == Record {
		config = experiment.config
		_run = experiment.run(forNumberOfTrials:onTrialComplete:)
	}
	
	public func run(forNumberOfTrials numberOfTrials: Int, onTrialComplete: (Record, Int) -> Void) {
		_run(numberOfTrials, onTrialComplete)
	}
	
}

public protocol ExperimentRecord {
	
	associatedtype Record : TrialRecord
	
	var config: ExperimentConfig { get }
	
	var trials: [Record] { get }
	
}

public protocol TrialRecord {
	
	associatedtype IndividualType : Individual
	
	var evaluations: [AnyEvaluationRecord<IndividualType>] { get }
	
}

public struct AnyTrialRecord<IndividualType : Individual> : TrialRecord {
	
	public let evaluations: [AnyEvaluationRecord<IndividualType>]
	
	public init<Record : TrialRecord>(_ record: Record) where Record.IndividualType == IndividualType {
		evaluations = record.evaluations
	}
	
}

public struct ComposedTrialRecord<IndividualType : Individual> : TrialRecord {
	
	public var evaluations: [AnyEvaluationRecord<IndividualType>] = []
}

public protocol EvaluationRecord {
	
	associatedtype IndividualType : Individual
	
	var name: String { get }
	
	var populations: [Population<IndividualType>] { get }
	
	var tasks: [Task] { get }
	
}

public struct AnyEvaluationRecord<IndividualType : Individual> : EvaluationRecord {
	
	public typealias PopulationType = Population<IndividualType>
	
	public let name: String
	
	public let populations: [PopulationType]
	
	public let tasks: [Task]
	
	public init<RecordType : EvaluationRecord>(_ record: RecordType) where RecordType.IndividualType == IndividualType {
		name = record.name
		populations = record.populations
		tasks = record.tasks
	}
	
}

struct ExperimentOverview<Record : TrialRecord> {
	
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
	
	mutating func accumulate(_ trial: Record) {
		for evaluation in trial.evaluations {
			accumulate(evaluation)
		}
	}
	
	mutating func accumulate<Record : EvaluationRecord>(_ evaluation: Record) {
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
