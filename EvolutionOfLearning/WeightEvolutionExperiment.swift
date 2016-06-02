//
//  WeightEvolutionExperiment.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/26/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct NetworkEvolutionExperiment : Experiment {
	
	public var tasks: [Task]
	
	public var config: ExperimentConfig
	
	public func run(forNumberOfTrials numberOfTrials: Int, onTrialComplete: (TrialRecord, Int) -> Void) {
		for i in 0..<numberOfTrials {
			let trial = makeTrial()
			let record = trial.run()
			onTrialComplete(record, i)
		}
	}
	
	private func makeTrial() -> NetworkEvolutionTrial {
		let selectedTasks = selectTasks(from: tasks, count: config.evolutionaryTaskCount)
		return NetworkEvolutionTrial(tasks: selectedTasks, config: config)
	}
	
	private func selectTasks(from tasks: [Task], count: Int) -> [Task] {
		var tasks = tasks
		var selectedTasks = [Task]()
		
		for _ in 0..<count {
			let index = Int(arc4random_uniform(UInt32(tasks.count)))
			let task = tasks.removeAtIndex(index)
			selectedTasks.append(task)
		}
		
		assert(selectedTasks.count == count)
		
		return selectedTasks
	}
	
}
