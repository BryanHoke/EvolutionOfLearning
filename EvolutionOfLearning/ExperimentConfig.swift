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
	
	case learningNetworkEvolution
	
	static var allConditions: [ExperimentalCondition] {
		return [.learningRuleEvolution, .networkEvolution, .learningNetworkEvolution]
	}
	
	public var name: String {
		switch self {
		case .learningRuleEvolution:
			return "Learning Rule Evolution"
		case .networkEvolution:
			return "Network Evolution"
		case .learningNetworkEvolution:
			return "Learning Network Evolution"
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

/// The parameters used for fitness evaluation.
public struct FitnessConfig {
	
	/// Whether learning rules are evolved.
	public var usesLearningRuleEvolution = true
	
	/// The number of genes used to encode the learning rule.
	///
	/// Has no effect if `usesLearningRuleEvolution == false`.
	public var learningRuleSize = 35
	
	/// The number of times to train each network before evaluating its fitness.
	///
	/// Has no effect if `usesLearningRuleEvolution == false`.
	public var numberOfTrainingEpochs = 10
	
	/// Whether networks are evolved.
	public var usesNetworkEvolution = true
	
	/// The number of genes used to encode each network weight.
	public var bitsPerWeight = 4
	
	/// Shifts the exponent used to decode weights from genes.
	public var encodingExponentShift = -2
	
	/// Whether network performance during training counts toward fitness.
	public var trainingCountsTowardFitness = true
	
}

extension FitnessConfig : OutputStringConvertible {
	
	public var outputDescription: String {
		return
			((usesLearningRuleEvolution ?
				[
					"learningRuleSize: \(learningRuleSize)",
					"numberOfTrainingEpochs: \(numberOfTrainingEpochs)",
					"trainingCountsTowardFitness: \(trainingCountsTowardFitness)"
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

/// The parameters used for reproduction.
public struct ReproductionConfig {
	
	/// The number of individuals to select using elitist selection.
	public var elitismCount = 1
	
	/// The proportion of the population that should be reproduced using crossover.
	public var crossoverRate = 0.8
	
	/// The frequency with which individual genes should be mutated.
	public var mutationRate = 0.01
	
	/// Whether mutation should apply to the individuals chosen by elitist selection.
	public var mutatesEliteIndividuals = true
	
}

extension ReproductionConfig : OutputStringConvertible {
	
	public var outputDescription: String {
		return [
			"elitismCount: \(elitismCount)",
			"crossoverRate: \(crossoverRate)",
			"mutationRate: \(mutationRate)",
			"mutatesEliteIndividuals: \(mutatesEliteIndividuals)"
		].joinWithSeparator("\n")
	}
	
}
