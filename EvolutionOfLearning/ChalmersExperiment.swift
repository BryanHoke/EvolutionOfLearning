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
	
	public var evolutionaryTaskCount: Int
	
	public func run(forNumberOfTrials numberOfTrials: Int) -> ChalmersExperimentRecord {
		guard evolutionaryTaskCount > 0 && tasks.count > evolutionaryTaskCount else {
			preconditionFailure("The number of evolutionary tasks (\(evolutionaryTaskCount) must be less than the total number of tasks (\(tasks.count)")
		}
		
		var records: [ChalmersTrialRecord] = []
		
		for _ in 0..<numberOfTrials {
			let record = runTrial()
			records.append(record)
		}
		
		return ChalmersExperimentRecord(trialRecords: records)
	}
	
	private func runTrial() -> ChalmersTrialRecord {
		let trial = makeTrial()
		return trial.run()
	}
	
	private func makeTrial() -> ChalmersTrial {
		
		let bifurcatedTasks = bifurcate(tasks, evolutionaryTaskCount: evolutionaryTaskCount)
		return ChalmersTrial(evolutionaryTasks: bifurcatedTasks.evolutionary, testTasks: bifurcatedTasks.test)
	}
	
	private func bifurcate(tasks: [Task], evolutionaryTaskCount count: Int) -> (evolutionary: [Task], test: [Task]) {
		var tasks = tasks
		var evolutionaryTasks: [Task] = []
		
		for _ in 0..<count {
			let index = Int(arc4random_uniform(UInt32(tasks.count)))
			let task = tasks.removeAtIndex(index)
			evolutionaryTasks.append(task)
		}
		
		assert(evolutionaryTasks.count == evolutionaryTaskCount)
		assert(tasks.count == self.tasks.count - evolutionaryTaskCount)
		
		return (evolutionary: evolutionaryTasks, test: tasks)
	}
	
}

public struct ChalmersExperimentRecord {
	
	public var trialRecords: [ChalmersTrialRecord]
	
}