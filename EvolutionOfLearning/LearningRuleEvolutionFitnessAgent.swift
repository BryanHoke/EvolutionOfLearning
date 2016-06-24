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
		
		learningRule.train(&network, on: task, numberOfTimes: numberOfTrainingEpochs)
		
		return fitness(of: network, on: task)
	}
	
	func makeNetwork(for task: Task) -> FeedForwardNeuralNetwork {
		return SingleLayerSingleOutputNeuralNetwork(
			size: task.inputCount + 1,
			activation: sigmoid(λ: 1))
	}
	
}
