//
//  Evolution.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/6/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct Evolution<EnvironmentType : Environment> {
	
	public typealias IndividualType = EnvironmentType.IndividualType
	
	public typealias PopulationType = Population<IndividualType>
	
	public var config: EvolutionConfig
	
	public var numberOfGenerations: Int {
		return config.numberOfGenerations
	}
	
	public var environment: EnvironmentType
	
	public var tasks: [Task] {
		return environment.tasks
	}
	
	public func run() -> EvolutionRecord<IndividualType> {
		print("Evolution")
		var history: [PopulationType] = []
		let geneticAlgorithm = GeneticAlgorithm(environment: environment, onPopulationEvaluated: { population in
			history.append(population)
		})
		geneticAlgorithm.run(forNumberOfGenerations: numberOfGenerations)
		return EvolutionRecord(history: history, tasks: tasks)
	}
	
}

public struct EvolutionRecord<IndividualType : Individual> {
	
	public var history: [Population<IndividualType>]
	
	public var tasks: [Task]
	
}

extension EvolutionRecord : EvaluationRecord {
	
	public var name: String { return "Evolution" }
	
	public var populations: [Population<IndividualType>] {
		return history
	}
	
}
