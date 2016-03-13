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
	
	public var fitnessConfig = FitnessConfig()
	
	public var geneticAlgorithmConfig = GeneticAlgorithmConfig()
	
}

public struct FitnessConfig {
	
	public var learningRuleSize = 35
	
	public var populationSize = 40
	
	public var numberOfTrainingEpochs = 10
	
}

public struct GeneticAlgorithmConfig {
	
	public var elitismCount = 1
	
	public var crossoverRate = 0.8
	
	public var mutationRate = 0.01
	
	public var numberOfGenerations = 1000
	
}