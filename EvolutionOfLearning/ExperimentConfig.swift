//
//  ExperimentConfig.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/11/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct ExperimentConfig {
	
	public var evolutionaryTaskCount = 20
	
	public var testTaskCount = 10
	
	public var environmentConfig = EnvironmentConfig()
	
	public var fitnessConfig = FitnessConfig()
	
	public var evolutionConfig = EvolutionConfig()
	
	public var reproductionConfig = ReproductionConfig()
	
}

public struct EnvironmentConfig {
	
	public var populationSize = 40
	
}

public struct FitnessConfig {
	
	public var learningRuleSize = 35
	
	public var numberOfTrainingEpochs = 10
	
}

public struct EvolutionConfig {
	
	public var numberOfGenerations = 1000
	
}

public struct ReproductionConfig {
	
	public var elitismCount = 1
	
	public var crossoverRate = 0.8
	
	public var mutationRate = 0.01
	
}