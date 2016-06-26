//
//  LearningNetworkEvolutionExperiment.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/25/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct LearningNetworkEvolutionExperiment<IndividualType : Individual> : Experiment {
	
	public typealias Record = AnyTrialRecord<IndividualType>
	
	public var tasks: [Task]
	
	public var config: ExperimentConfig
	
	public func run(forNumberOfTrials numberOfTrials: Int, onTrialComplete: (Record, Int) -> Void) {
		guard config.evolutionaryTaskCount > 0 && tasks.count > config.evolutionaryTaskCount else {
			preconditionFailure("The number of evolutionary tasks (\(config.evolutionaryTaskCount) must be less than the total number of tasks (\(tasks.count)")
		}
		
		for i in 0..<numberOfTrials {
			print("Trial \(i)")
			let trial = makeTrial()
			let record = AnyTrialRecord(trial.run())
			onTrialComplete(record, i)
		}
	}
	
	private func makeTrial() -> LearningNetworkEvolutionTrial<IndividualType> {
		let selected = selectTasks(from: tasks, evolutionaryTaskCount: config.evolutionaryTaskCount, testTaskCount: config.testTaskCount)
		return LearningNetworkEvolutionTrial(
			evolutionaryTasks: selected.evolutionary,
			testTasks: selected.test,
			config: config)
	}
	
	private func selectTasks(from tasks: [Task], evolutionaryTaskCount: Int, testTaskCount: Int) -> (evolutionary: [Task], test: [Task]) {
		var tasks = tasks
		let evolutionaryTasks = extractTasks(from: &tasks, count: evolutionaryTaskCount)
		let testTasks = extractTasks(from: &tasks, count: testTaskCount)
		
		assert(evolutionaryTasks.count == evolutionaryTaskCount)
		assert(testTasks.count == testTaskCount)
		
		return (evolutionary: evolutionaryTasks, test: testTasks)
	}
	
	private func extractTasks(inout from tasks: [Task], count: Int) -> [Task] {
		var extractedTasks: [Task] = []
		for _ in 0..<count {
			let index = Int(arc4random_uniform(UInt32(tasks.count)))
			let task = tasks.removeAtIndex(index)
			extractedTasks.append(task)
		}
		return extractedTasks
	}
	
}

public struct LearningNetworkEvolutionExperimentRecord<Record : TrialRecord> {
	
	public typealias IndividualType = Record.IndividualType
	
	public var config: ExperimentConfig
	
	public var trialRecords: [Record]
	
}

extension LearningNetworkEvolutionExperimentRecord : ExperimentRecord {
	
	public var trials: [Record] {
		return trialRecords.map { $0 as Record }
	}
	
}
