//
//  ChalmersTrial.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/11/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public typealias FitnessAgentFactory = (tasks: [Task]) -> FitnessAgent

public struct ChalmersTrial {
	
	public var evolutionaryTasks: [Task]
	
	public var testTasks: [Task]
	
	public func run() -> ChalmersTrialRecord {
		let evolutionRecord = runEvolution()
		
		let testRecord = runLearningTest(with: evolutionRecord.history)
		
		return ChalmersTrialRecord(evolutionRecord: evolutionRecord, learningTestRecord: testRecord)
	}
	
	private func runEvolution() -> EvolutionRecord {
		let fitness = makeFitnessAgent(with: evolutionaryTasks)
		let reproduction = ChalmersReproductionAgent(elitismCount: 1, mutationRate: 0.01, crossoverRate: 0.8)
		let environment = Environment(populationSize: 40, fitnessAgent: fitness, reproductionAgent: reproduction)
		let evolution = Evolution(environment: environment, numberOfGenerations: 1000)
		return evolution.run()
	}
	
	private func runLearningTest(with history: [Population]) -> LearningTestRecord {
		let fitness = makeFitnessAgent(with: testTasks)
		let learningTest = LearningTest(fitnessAgent: fitness, history: history)
		return learningTest.run()
	}
	
	private func makeFitnessAgent(with tasks: [Task]) -> FitnessAgent {
		return ChalmersFitnessAgent(learningRuleSize: 35, numberOfTrainingEpochs: 10, tasks: tasks)
	}
	
}

public struct ChalmersTrialRecord {
	
	public var evolutionRecord: EvolutionRecord
	
	public var learningTestRecord: LearningTestRecord
	
}

// TODO: Relocate this when needed
private func bifurcate(tasks: [Task], evolutionaryTaskCount count: Int) -> (evolutionary: [Task], test: [Task]) {
	var tasks = tasks
	var evolutionaryTasks: [Task] = []
	
	for _ in 0..<count {
		let index = Int(arc4random_uniform(UInt32(tasks.count)))
		let task = tasks.removeAtIndex(index)
		evolutionaryTasks.append(task)
	}
	
	return (evolutionary: evolutionaryTasks, test: tasks)
}
