//
//  Evolution.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/6/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct Evolution {
	
	public init(environment: EvolutionaryEnvironment, numberOfGenerations: Int) {
		self.environment = environment
		self.numberOfGenerations = numberOfGenerations
	}
	
	public var numberOfGenerations: Int
	
	public var environment: EvolutionaryEnvironment
	
	public var tasks: [Task] {
		return environment.tasks
	}
	
	public func run() -> EvolutionRecord {
		var history: [Population] = []
		let geneticAlgorithm = GeneticAlgorithm(environment: environment, onPopulationEvaluated: { history.append($0) })
		geneticAlgorithm.run(forNumberOfGenerations: numberOfGenerations)
		return EvolutionRecord(history: history, tasks: tasks)
	}
	
}

public struct EvolutionRecord {
	
	public var history: [Population]
	
	public var tasks: [Task]
	
}
