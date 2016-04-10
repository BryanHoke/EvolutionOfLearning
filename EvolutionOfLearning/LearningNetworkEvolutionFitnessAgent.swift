//
//  LearningNetworkEvolutionFitnessAgent.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 4/10/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct ExtendedChalmersFitnessAgent: FitnessAgent {
	
	public init(bitsPerWeight: Int, exponentialCap: Int, learningRuleSize: Int, numberOfTrainingEpochs: Int, tasks: [Task]) {
		self.bitsPerWeight = bitsPerWeight
		self.exponentialCap = exponentialCap
		self.learningRuleSize = learningRuleSize
		self.numberOfTrainingEpochs = numberOfTrainingEpochs
		self.tasks = tasks
		self.exponentShift = exponentOffset(bitCount: bitsPerWeight, cap: exponentialCap)
		geneMap = GeneMap(bitsPerWeight: bitsPerWeight, offset: learningRuleSize)
		buildGeneMap()
	}
	
	/// Preferred value is `3`.
	public let bitsPerWeight: Int
	
	/// Preferred value is `4`.
	public let exponentialCap: Int
	
	/// Preferred value is `35`.
	public let learningRuleSize: Int
	
	/// Preferred value is `10`.
	public let numberOfTrainingEpochs: Int
	
	public let tasks: [Task]
	
	private let exponentShift: Int
	
	// TODO: Test
	private func computeExponentShift() -> Int {
		return pow(2, bitsPerWeight - 1) - 1 - exponentialCap
	}
	
	private var geneMap: GeneMap
	
	private mutating func buildGeneMap() {
		for task in tasks {
			geneMap.addMapping(for: task)
		}
	}
	
	// TODO: Test
	public func seed() -> Chromosome {
		let size = geneMap.chromosomeSize
		return Chromosome(size: size, seed: randomBool)
	}
	
	// TODO: Test
	public func fitness(of chromosome: Chromosome, on task: Task) -> Double {
		guard let geneRange = geneMap.geneRange(of: task) else {
			return 0
		}
		
		let genes = Array(chromosome[geneRange])
		var network = makeNetwork(for: task, genes: genes)
		
		let learningRuleGenes = Array(chromosome[0..<learningRuleSize])
		let learningRule = ChalmersLearningRule(bits: learningRuleGenes)
		
		learningRule.trainNetwork(&network, task: task, numberOfTimes: numberOfTrainingEpochs)
		return fitness(of: network, on: task)
	}
	
	func makeNetwork(`for` task: Task, genes: [Bool]) -> FeedForwardNeuralNetwork {
		let weights = makeWeights(for: task, genes: genes)
		return SingleLayerSingleOutputNeuralNetwork(
			weights: weights,
			activation: sigmoid(λ: 1))
	}
	
	// TODO: Test
	func makeWeights(`for` task: Task, genes: [Bool]) -> [Double] {
		let encoding = signedExponentialEncoding(with: exponentShift)
		return decodeWeights(from: genes,
		                     bitsPerWeight: bitsPerWeight,
		                     layerSize: task.inputCount,
		                     encoding: encoding)
	}
	
}
