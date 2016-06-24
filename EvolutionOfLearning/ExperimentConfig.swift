//
//  ExperimentConfig.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/11/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public protocol OutputStringConvertible {
	
	var outputDescription: String { get }
	
}

public enum ExperimentalCondition: Int {
	
	case learningRuleEvolution
	
	case networkEvolution
	
	static var allConditions: [ExperimentalCondition] {
		return [.learningRuleEvolution, .networkEvolution]
	}
	
	public var name: String {
		switch self {
		case .learningRuleEvolution:
			return "Learning Rule Evolution"
		case .networkEvolution:
			return "Network Evolution"
		}
	}
	
}

public struct ExperimentConfig {
	
	public var evolutionaryTaskCount = 20
	
	public var testTaskCount = 10
	
	public var environmentConfig = EnvironmentConfig()
	
	public var fitnessConfig = FitnessConfig()
	
	public var evolutionConfig = EvolutionConfig()
	
	public var reproductionConfig = ReproductionConfig()
	
}

extension ExperimentConfig : OutputStringConvertible {
	
	public var outputDescription: String {
		return ([
			"evolutionaryTaskCount: \(evolutionaryTaskCount)",
			"testTaskCount: \(testTaskCount)"
			]
			+ ([
				evolutionConfig,
				environmentConfig,
				fitnessConfig,
				reproductionConfig
				] as [OutputStringConvertible])
				.map({ $0.outputDescription }))
			.joinWithSeparator("\n")
	}
	
}

public struct EnvironmentConfig {
	
	public var populationSize = 40
	
}

extension EnvironmentConfig : OutputStringConvertible {
	
	public var outputDescription: String {
		return "populationSize: \(populationSize)"
	}
	
}

public struct FitnessConfig {
	
	public var usesLearningRuleEvolution = true
	
	public var learningRuleSize = 35
	
	public var numberOfTrainingEpochs = 10
	
	public var usesNetworkEvolution = true
	
	public var bitsPerWeight = 4
	
	public var encodingExponentShift = -2
	
	public var trainingCountsTowardFitness = false
	
}

extension FitnessConfig : OutputStringConvertible {
	
	public var outputDescription: String {
		return
			((usesLearningRuleEvolution ?
				[
					"learningRuleSize: \(learningRuleSize)",
					"numberOfTrainingEpochs: \(numberOfTrainingEpochs)"
				]
				: [])
				+
				(usesNetworkEvolution ?
					[
						"bitsPerWeight: \(bitsPerWeight)",
						"encodingExponentShift: \(encodingExponentShift)"
					]
					: [])
				).joinWithSeparator("\n")
	}
	
}

public struct EvolutionConfig {
	
	public var numberOfGenerations = 1000
	
}

extension EvolutionConfig : OutputStringConvertible {
	
	public var outputDescription: String {
		return "numberOfGenerations: \(numberOfGenerations)"
	}
	
}

public struct ReproductionConfig {
	
	public var elitismCount = 1
	
	public var crossoverRate = 0.8
	
	public var mutationRate = 0.01
	
}

extension ReproductionConfig : OutputStringConvertible {
	
	public var outputDescription: String {
		return [
			"elitismCount: \(elitismCount)",
			"crossoverRate: \(crossoverRate)",
			"mutationRate: \(mutationRate)"
		].joinWithSeparator("\n")
	}
	
}
