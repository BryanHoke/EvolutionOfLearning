//
//  LearningNetworkEvolutionFitnessAgent.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 4/10/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct LearningNetworkEvolutionFitnessAgent<ChromosomeType : Chromosome> : FitnessAgent {
	
	public init(config: FitnessConfig, tasks: [Task]) {
		self.config = config
		self.tasks = tasks
		geneMap = GeneMap(bitsPerWeight: config.bitsPerWeight, offset: config.learningRuleSize)
		buildGeneMap()
	}
	
	public let config: FitnessConfig
	
	public var bitsPerWeight: Int {
		return config.bitsPerWeight
	}
	
	public var exponentShift: Int {
		return config.encodingExponentShift
	}
	
	public var learningRuleSize: Int {
		return config.learningRuleSize
	}
	
	public var numberOfTrainingEpochs: Int {
		return config.numberOfTrainingEpochs
	}
	
	public let tasks: [Task]
	
	private var geneMap: GeneMap
	
	private mutating func buildGeneMap() {
		for task in tasks {
			geneMap.addMapping(for: task)
		}
	}
	
	// TODO: Test
	public func seed() -> ChromosomeType {
		let sizes = [learningRuleSize] + geneMap.mapping.map { (mapping: (index: Int, range: Range<Int>)) -> Int in
			mapping.range.count
		}
		return ChromosomeType.init(segmentSizes: sizes, seed: randomBool)
	}
	
	// TODO: Test
	public func fitness(of chromosome: ChromosomeType, on task: Task) -> Double {
		guard let geneRange = geneMap.geneRange(of: task) else {
			return 0
		}
		
		let genes = Array(chromosome[geneRange])
		var network = makeNetwork(for: task, genes: genes)
		
		let learningRuleGenes = Array(chromosome[0..<learningRuleSize])
		let learningRule = ChalmersLearningRule(bits: learningRuleGenes)
		
		var fitness = 0.0
		var denominator = 1
		
		if config.trainingCountsTowardFitness {
			for _ in 0..<numberOfTrainingEpochs {
				fitness += accuracy(of: network, on: task)
				learningRule.train(&network, on: task)
			}
			denominator += numberOfTrainingEpochs
		} else {
			learningRule.train(&network, on: task, numberOfTimes: numberOfTrainingEpochs)
		}
		
		fitness += accuracy(of: network, on: task)
		fitness /= Double(denominator)
		return fitness
	}
	
	func makeNetwork(for task: Task, genes: [Bool]) -> FeedForwardNeuralNetwork {
		let weights = makeWeights(for: task, genes: genes)
		return SingleLayerSingleOutputNeuralNetwork(
			weights: weights,
			activation: sigmoid(λ: 1))
	}
	
	// TODO: Test
	func makeWeights(for task: Task, genes: [Bool]) -> [Double] {
		let encoding = signedExponentialEncoding(exponentOffset: exponentShift)
		return decodeWeights(from: genes,
		                     bitsPerWeight: bitsPerWeight,
		                     layerSize: task.inputCount + 1,
		                     encoding: encoding)
	}
	
}
