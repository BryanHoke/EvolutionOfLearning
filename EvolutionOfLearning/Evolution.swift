//
//  Evolution.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/6/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct Evolution {
	
	public var config: EvolutionConfig
	
	public var numberOfGenerations: Int {
		return config.numberOfGenerations
	}
	
	public var environment: EvolutionaryEnvironment
	
	public var tasks: [Task] {
		return environment.tasks
	}
	
	public func run() -> EvolutionRecord {
		print("Evolution")
		var history: [Population] = []
		let geneticAlgorithm = GeneticAlgorithm(environment: environment, onPopulationEvaluated: { population in
			history.append(population)
		})
		geneticAlgorithm.run(forNumberOfGenerations: numberOfGenerations)
		return EvolutionRecord(history: history, tasks: tasks)
	}
	
}

public struct EvolutionRecord {
	
	public var history: [Population]
	
	public var tasks: [Task]
	
}

extension EvolutionRecord : EvaluationRecord {
	
	public var name: String { return "Evolution" }
	
	public var populations: [Population] {
		return history
	}
	
}
