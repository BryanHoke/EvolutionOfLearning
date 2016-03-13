//
//  ChalmersExperiment.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 9/9/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public struct ChalmersExperiment {
	
	public var tasks: [Task]
	
	public var config: ExperimentConfig
	
	public func run(forNumberOfTrials numberOfTrials: Int) -> ChalmersExperimentRecord {
		guard config.evolutionaryTaskCount > 0 && tasks.count > config.evolutionaryTaskCount else {
			preconditionFailure("The number of evolutionary tasks (\(config.evolutionaryTaskCount) must be less than the total number of tasks (\(tasks.count)")
		}
		
		var records: [ChalmersTrialRecord] = []
		
		for _ in 0..<numberOfTrials {
			let record = runTrial()
			records.append(record)
		}
		
		return ChalmersExperimentRecord(evolutionaryTaskCount: config.evolutionaryTaskCount, testTaskCount: config.testTaskCount, trialRecords: records)
	}
	
	private func runTrial() -> ChalmersTrialRecord {
		let trial = makeTrial()
		return trial.run()
	}
	
	private func makeTrial() -> ChalmersTrial {
		let selected = selectTasks(from: tasks, evolutionaryTaskCount: config.evolutionaryTaskCount, testTaskCount: config.testTaskCount)
		return ChalmersTrial(
			evolutionaryTasks: selected.evolutionary,
			testTasks: selected.test,
			config: config)
	}
	
	private func selectTasks(from tasks: [Task], evolutionaryTaskCount: Int, testTaskCount: Int) -> (evolutionary: [Task], test: [Task]) {
		var tasks = tasks
		let evolutionaryTasks = extractTasks(from: &tasks, count: evolutionaryTaskCount)
		let testTasks = extractTasks(from: &tasks, count: testTaskCount)
		
		assert(evolutionaryTasks.count == evolutionaryTaskCount)
		assert(tasks.count == self.tasks.count - evolutionaryTaskCount)
		
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

public struct ChalmersExperimentRecord {
	
	public var evolutionaryTaskCount: Int
	
	public var testTaskCount: Int
	
	public var trialRecords: [ChalmersTrialRecord]
	
}