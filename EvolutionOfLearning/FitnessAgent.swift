//
//  FitnessAgent.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 11/7/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public protocol FitnessAgent {
	
	func seeding(with tasks: [Task]) -> () -> GeneticIndividual
	
	func fitness(of chromosome: Chromosome, on task: Task) -> Double
	
}

extension FitnessAgent {
	
	public func fitness(of network: FeedForwardNeuralNetwork, on task: Task) -> Double {
		let error = network.testOnTask(task)
		let meanError = error / Double(task.patterns.count)
		return 1.0 - meanError
	}
	
}

public struct ChalmersFitnessAgent: FitnessAgent {
	
	public var historyLength = 15
	
	public let learningRuleSize = 35
	
	public var numberOfTrainingEpochs = 10
	
	/// The list of fitness values measured per `Chromosome`, in order of recording.
	var fitnessHistory = [Chromosome: [Double]]()
	
	public func seeding(with tasks: [Task]) -> () -> GeneticIndividual {
		return {
			let chromosome = Chromosome(size: self.learningRuleSize, seed: randomBool)
			return Individual(chromosome: chromosome)
		}
	}
	
	public func fitness(of chromosome: Chromosome, on task: Task) -> Double {
		var network = SingleLayerSingleOutputNeuralNetwork(
			size: task.inputCount + 1,
			activation: sigmoid(λ: 1)) as FeedForwardNeuralNetwork
		let learningRule = ChalmersLearningRule(
			bits: chromosome.genes)
		learningRule.trainNetwork(&network, task: task, numberOfTimes: numberOfTrainingEpochs)
		return fitness(of: network, on: task)
	}
	
}

public struct WeightEvolutionFitnessAgent: FitnessAgent {
	
	public init(bitsPerWeight: Int, exponentialCap: Int, tasks: [Task]) {
		self.bitsPerWeight = bitsPerWeight
		self.exponentialCap = exponentialCap
		self.tasks = tasks
		geneMap = GeneMap(bitsPerWeight: bitsPerWeight, offset: 0)
		buildGeneMap()
	}
	
	/// Preferred value is `3`.
	public let bitsPerWeight: Int
	
	/// Preferred value is `4`.
	public let exponentialCap: Int
	
	public let tasks: [Task]
	
	var geneMap: GeneMap
	
	private mutating func buildGeneMap() {
		for task in tasks {
			geneMap.addMapping(`for`: task)
		}
	}
	
	// TODO: Test
	public func seeding(with tasks: [Task]) -> () -> GeneticIndividual {
		let size = geneMap.chromosomeSize
		return {
			let chromosome = Chromosome(size: size, seed: randomBool)
			return Individual(chromosome: chromosome)
		}
	}
	
	// TODO: Test
	public func fitness(of chromosome: Chromosome, on task: Task) -> Double {
		guard let geneRange = geneMap.geneRange(of: task) else {
				return 0
		}
		
		let genes = Array(chromosome[geneRange])
		
		let encoding = signedExponentialEncodingWithOffset(exponentShift)
		let weights = decodeWeightsFrom(genes, bitsPerWeight: bitsPerWeight, layerSize: task.inputCount, encoding: encoding)
		let network = SingleLayerSingleOutputNeuralNetwork(weights: weights, activation: sigmoid(λ: 1))
		return fitness(of: network, on: task)
	}
	
	// TODO: Test
	var exponentShift: Int {
		return Int(pow(2.0, Double(bitsPerWeight - 1)) - 1) - exponentialCap
	}
	
}

public struct ExtendedChalmersFitnessAgent: FitnessAgent {
	
	public init(bitsPerWeight: Int, exponentialCap: Int, learningRuleSize: Int, numberOfTrainingEpochs: Int, tasks: [Task]) {
		self.bitsPerWeight = bitsPerWeight
		self.exponentialCap = exponentialCap
		self.learningRuleSize = learningRuleSize
		self.numberOfTrainingEpochs = numberOfTrainingEpochs
		self.tasks = tasks
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
	public var numberOfTrainingEpochs: Int
	
	public let tasks: [Task]
	
	var geneMap: GeneMap
	
	private mutating func buildGeneMap() {
		for task in tasks {
			geneMap.addMapping(`for`: task)
		}
	}
	
	public func seeding(with tasks: [Task]) -> () -> GeneticIndividual {
		let size = geneMap.chromosomeSize
		return {
			let chromosome = Chromosome(size: size, seed: randomBool)
			return Individual(chromosome: chromosome)
		}
	}
	
	// TODO: Test
	public func fitness(of chromosome: Chromosome, on task: Task) -> Double {
		guard let geneRange = geneMap.geneRange(of: task) else {
			return 0
		}
		
		let genes = Array(chromosome[geneRange])
		let exponentShift = Int(pow(2.0, Double(bitsPerWeight - 1)) - 1) - exponentialCap
		let encoding = signedExponentialEncodingWithOffset(exponentShift)
		let weights = decodeWeightsFrom(genes, bitsPerWeight: bitsPerWeight, layerSize: task.inputCount, encoding: encoding)
		var network = SingleLayerSingleOutputNeuralNetwork(weights: weights, activation: sigmoid(λ: 1)) as FeedForwardNeuralNetwork
		
		let learningRuleGenes = [Bool](chromosome[0..<learningRuleSize])
		let learningRule = ChalmersLearningRule(bits: learningRuleGenes)
		learningRule.trainNetwork(&network, task: task, numberOfTimes: numberOfTrainingEpochs)
		
		return fitness(of: network, on: task)
	}
	
	// TODO: Test
	var exponentShift: Int {
		return Int(pow(2.0, Double(bitsPerWeight - 1)) - 1) - exponentialCap
	}
	
}