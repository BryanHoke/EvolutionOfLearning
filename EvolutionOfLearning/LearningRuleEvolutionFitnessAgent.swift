//
//  LearningRuleEvolutionFitnessAgent.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 4/10/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct LearningRuleEvolutionFitnessAgent<ChromosomeType : Chromosome> : FitnessAgent {
	
	public var config: FitnessConfig
	
	public var learningRuleSize: Int {
		return config.learningRuleSize
	}
	
	public var numberOfTrainingEpochs: Int {
		return config.numberOfTrainingEpochs
	}
	
	public var tasks: [Task]
	
	// TODO: Test
	public func seed() -> ChromosomeType {
		let sizes = [5] + [Int](count: 10, repeatedValue: 3)
		return ChromosomeType.init(segmentSizes: sizes, seed: randomBool)
	}
	
	// TODO: Test
	public func fitness(of chromosome: ChromosomeType, on task: Task) -> Double {
		var network = makeNetwork(for: task)
		
		let learningRule = ChalmersLearningRule(
			bits: chromosome.genes)
		
		var fitness = 0.0
		var denominator = 1
		
		for _ in 0..<numberOfTrainingEpochs {
			if config.trainingCountsTowardFitness {
				fitness += self.fitness(of: network, on: task)
				denominator += 1
			}
			learningRule.train(&network, on: task)
		}
		
		fitness += self.fitness(of: network, on: task)
		fitness /= Double(denominator)
		return fitness
	}
	
	func makeNetwork(for task: Task) -> FeedForwardNeuralNetwork {
		return SingleLayerSingleOutputNeuralNetwork(
			size: task.inputCount + 1,
			activation: sigmoid(λ: 1))
	}
	
}
