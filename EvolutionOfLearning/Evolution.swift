//
//  Evolution.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/6/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct Evolution {
	
	public init(environment: EvolutionaryEnvironment, numberOfGenerations: Int, populationSize: Int) {
		self.environment = environment
		self.numberOfGenerations = numberOfGenerations
		self.populationSize = populationSize
	}
	
	public let numberOfGenerations: Int
	
	public let populationSize: Int
	
	public let environment: EvolutionaryEnvironment
	
	public private(set) var history: [Population] = []
	
	public func run() -> [Population] {
		var history: [Population] = []
		let geneticAlgorithm = GeneticAlgorithm(environment: environment, onPopulationEvaluated: { history.append($0) })
		geneticAlgorithm.run(forGenerations: numberOfGenerations)
		return history
	}
	
}

public struct EvolutionRecord {
	
	let history: [Population]
	
	let tasks: [Task]
	
}
