//
//  FitnessAgent.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 11/7/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public protocol FitnessAgent {
	
	var tasks: [Task] { get }
	
	func seed() -> Chromosome
	
	func fitness(of chromosome: Chromosome, on task: Task) -> Double
	
}

extension FitnessAgent {
	
	public func fitness(of chromosome: Chromosome) -> Double {
		let totalFitness = tasks.reduce(0.0) { (total, task) -> Double in
			total + self.fitness(of: chromosome, on: task)
		}
		return totalFitness / Double(tasks.count)
	}
	
	public func fitness(of network: FeedForwardNeuralNetwork, on task: Task) -> Double {
		let error = network.testOnTask(task)
		let meanError = error / Double(task.patterns.count)
		return 1.0 - meanError
	}
	
}

public struct ChalmersFitnessAgent: FitnessAgent {
	
	public init(learningRuleSize: Int, numberOfTrainingEpochs: Int, tasks: [Task]) {
		self.learningRuleSize = learningRuleSize
		self.numberOfTrainingEpochs = numberOfTrainingEpochs
		self.tasks = tasks
	}
	
	/// Preferred value is `35`.
	public var learningRuleSize: Int
	
	/// Preferred value is `10`.
	public var numberOfTrainingEpochs: Int
	
	public var tasks: [Task]
	
	// TODO: Test
	public func seed() -> Chromosome {
		return Chromosome(size: learningRuleSize, seed: randomBool)
	}
	
	// TODO: Test
	public func fitness(of chromosome: Chromosome, on task: Task) -> Double {
		var network = makeNetwork(`for`: task)
		
		let learningRule = ChalmersLearningRule(
			bits: chromosome.genes)
		
		learningRule.trainNetwork(&network, task: task, numberOfTimes: numberOfTrainingEpochs)
		
		return fitness(of: network, on: task)
	}
	
	func makeNetwork(`for` task: Task) -> FeedForwardNeuralNetwork {
		return SingleLayerSingleOutputNeuralNetwork(
			size: task.inputCount + 1,
			activation: sigmoid(λ: 1))
	}
	
}

public struct WeightEvolutionFitnessAgent: FitnessAgent {
	
	public init(bitsPerWeight: Int, exponentialCap: Int, tasks: [Task]) {
		self.bitsPerWeight = bitsPerWeight
		self.exponentialCap = exponentialCap
		self.tasks = tasks
		self.exponentShift = exponentOffset(bitCount: bitsPerWeight, cap: exponentialCap)
		geneMap = GeneMap(bitsPerWeight: bitsPerWeight, offset: 0)
		buildGeneMap()
	}
	
	/// Preferred value is `3`.
	public let bitsPerWeight: Int
	
	/// Preferred value is `4`.
	public let exponentialCap: Int
	
	public let tasks: [Task]
	
	private let exponentShift: Int
	
	private var geneMap: GeneMap
	
	private mutating func buildGeneMap() {
		for task in tasks {
			geneMap.addMapping(`for`: task)
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
		let network = makeNetwork(`for`: task, genes: genes)
		
		return fitness(of: network, on: task)
	}
	
	func makeNetwork(`for` task: Task, genes: [Bool]) -> FeedForwardNeuralNetwork {
		let weights = makeWeights(`for`: task, genes: genes)
		return makeNetwork(`for`: weights)
	}
	
	func makeNetwork(`for` weights: [Double]) -> FeedForwardNeuralNetwork {
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
			geneMap.addMapping(`for`: task)
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
		var network = makeNetwork(`for`: task, genes: genes)
		
		let learningRuleGenes = Array(chromosome[0..<learningRuleSize])
		let learningRule = ChalmersLearningRule(bits: learningRuleGenes)
		
		learningRule.trainNetwork(&network, task: task, numberOfTimes: numberOfTrainingEpochs)
		return fitness(of: network, on: task)
	}
	
	func makeNetwork(`for` task: Task, genes: [Bool]) -> FeedForwardNeuralNetwork {
		let weights = makeWeights(`for`: task, genes: genes)
		return makeNetwork(`for`: weights)
	}
	
	func makeNetwork(`for` weights: [Double]) -> FeedForwardNeuralNetwork {
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