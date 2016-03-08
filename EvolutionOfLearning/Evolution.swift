//
//  Evolution.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/6/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct Evolution {
	
	public init(environment: EvolutionaryEnvironment, numberOfGenerations: Int, numberOfTrials: Int, populationSize: Int, onPopulationEvaluated: ((population: Population) -> Void)? = nil) {
		geneticAlgorithm = GeneticAlgorithm(environment: environment, onPopulationEvaluated: onPopulationEvaluated)
		self.numberOfGenerations = numberOfGenerations
		self.numberOfTrials = numberOfTrials
		self.populationSize = populationSize
	}
	
	public let numberOfGenerations: Int
	
	public let numberOfTrials: Int
	
	public let populationSize: Int
	
	private let geneticAlgorithm: GeneticAlgorithm
	
	public var environment: EvolutionaryEnvironment {
		return geneticAlgorithm.environment
	}
	
	public var onPopulationEvaluated: ((population: Population) -> Void)? {
		return geneticAlgorithm.onPopulationEvaluated
	}
	
	public private(set) var history: [Population] = []
	
	public func runTrials() {
		for _ in 0..<numberOfTrials {
			runTrial()
		}
	}
	
	private func runTrial() {
		geneticAlgorithm.run(forGenerations: numberOfGenerations, populationSize: populationSize)
	}
	
}