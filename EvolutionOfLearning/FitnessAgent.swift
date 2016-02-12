//
//  FitnessAgent.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 11/7/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

protocol FitnessAgent {
	
	func seedingFor(tasks: [Task]) -> () -> GeneticIndividual
	
	func fitnessOf(chromosome: Chromosome, on task: Task) -> Double
	
}

extension FitnessAgent {
	
	func fitnessOf(network: FeedForwardNeuralNetwork, on task: Task) -> Double {
		let error = network.testOnTask(task)
		let meanError = error / Double(task.patterns.count)
		return 1.0 - meanError
	}
	
}

struct ChalmersFitnessAgent: FitnessAgent {
	
	var historyLength = 15
	
	let learningRuleSize = 35
	
	var numberOfTrainingEpochs = 10
	
	/// The list of fitness values measured per `Chromosome`, in order of recording.
	var fitnessHistory = [Chromosome: [Double]]()
	
	func seedingFor(tasks: [Task]) -> () -> GeneticIndividual {
		return {
			let chromosome = Chromosome(size: self.learningRuleSize, seed: randomBool)
			return Individual(chromosome: chromosome)
		}
	}
	
	func fitnessOf(chromosome: Chromosome, on task: Task) -> Double {
		var network = SingleLayerSingleOutputNeuralNetwork(
			size: task.inputCount + 1,
			activation: sigmoid(1)) as FeedForwardNeuralNetwork
		let learningRule = ChalmersLearningRule(
			bits: chromosome.genes)
		learningRule.trainNetwork(&network, task: task, numberOfTimes: numberOfTrainingEpochs)
		return fitnessOf(network, on: task)
	}
	
}

struct WeightEvolutionFitnessAgent: FitnessAgent {
	
	let bitsPerWeight = 3
	
	let exponentialCap = 4
	
	var geneMap = IndexedDictionary<Int, Int>()
	
	func seedingFor(tasks: [Task]) -> () -> GeneticIndividual {
		let size = chromosomeSizeFor(tasks)
		return {
			let chromosome = Chromosome(size: size, seed: randomBool)
			return Individual(chromosome: chromosome)
		}
	}
	
	private func chromosomeSizeFor(tasks: [Task]) -> Int {
		return tasks.reduce(bitsPerWeight) { (sum, task) -> Int in
			sum + self.geneSize(of: task)
		}
	}
	
	private func geneSize(of task: Task) -> Int {
		return bitsPerWeight * task.width
	}
	
	// TODO: Test
	mutating func buildGeneMap(with tasks: [Task]) {
		for task in tasks {
			buildGeneMapEntry(of: task)
		}
	}
	
	private mutating func buildGeneMapEntry(of task: Task) {
		guard let taskID = task.id else {
			return
		}
		geneMap[taskID] = geneMapIndex(of: task)
	}
	
	private func geneMapIndex(of task: Task) -> Int {
		var index = 0
		if let prevIndex = geneMap.lastValue {
			index += prevIndex
		}
		index += geneSize(of: task)
		return index
	}
	
	// TODO: Test
	func fitnessOf(chromosome: Chromosome, on task: Task) -> Double {
		guard let taskID = task.id,
			tail = geneMap[taskID] else {
				return 0
		}
		
		var loc = 0
		if let prevIdx = geneMap.previousValueForKey(taskID) {
			loc = prevIdx
		}
		
		let genes = [Bool](chromosome[loc..<tail])
		
		let exponentShift = Int(pow(2.0, Double(bitsPerWeight - 1)) - 1) - exponentialCap
		let encoding = signedExponentialEncodingWithOffset(exponentShift)
		let weights = decodeWeightsFrom(genes, bitsPerWeight: bitsPerWeight, layerSize: task.inputCount, encoding: encoding)
		let network = SingleLayerSingleOutputNeuralNetwork(weights: weights, activation: sigmoid(1))
		return fitnessOf(network, on: task)
	}
	
}

struct ExtendedChalmersFitnessAgent: FitnessAgent {
	
	let bitsPerWeight = 3
	
	let exponentialCap = 4
	
	let learningRuleSize = 35
	
	var geneMap = IndexedDictionary<Int, Int>()
	
	var numberOfTrainingEpochs = 10
	
	func seedingFor(tasks: [Task]) -> () -> GeneticIndividual {
		let size = chromosomeSizeFor(tasks)
		return {
			let chromosome = Chromosome(size: size, seed: randomBool)
			return Individual(chromosome: chromosome)
		}
	}
	
	private func chromosomeSizeFor(tasks: [Task]) -> Int {
		return tasks.reduce(learningRuleSize + bitsPerWeight) { (sum, task) -> Int in
			sum + self.geneSize(of: task)
		}
	}
	
	private func geneSize(of task: Task) -> Int {
		return bitsPerWeight * task.width
	}
	
	// TODO: Test
	mutating func buildGeneMap(with tasks: [Task]) {
		for task in tasks {
			buildGeneMapEntry(of: task)
		}
	}
	
	private mutating func buildGeneMapEntry(of task: Task) {
		guard let taskID = task.id else {
			return
		}
		geneMap[taskID] = geneMapIndex(of: task)
	}
	
	private func geneMapIndex(of task: Task) -> Int {
		var index = 0
		if let prevIndex = geneMap.lastValue {
			index += prevIndex
		} else {
			index += learningRuleSize
		}
		index += geneSize(of: task)
		return index
	}
	
	// TODO: Test
	func fitnessOf(chromosome: Chromosome, on task: Task) -> Double {
		guard let taskID = task.id,
			tail = geneMap[taskID] else {
				return 0
		}
		var loc = 0
		if let prevIdx = geneMap.previousValueForKey(taskID) {
			loc = prevIdx
		}
		
		let genes = [Bool](chromosome[loc..<tail])
		let exponentShift = Int(pow(2.0, Double(bitsPerWeight - 1)) - 1) - exponentialCap
		let encoding = signedExponentialEncodingWithOffset(exponentShift)
		let weights = decodeWeightsFrom(genes, bitsPerWeight: bitsPerWeight, layerSize: task.inputCount, encoding: encoding)
		var network = SingleLayerSingleOutputNeuralNetwork(weights: weights, activation: sigmoid(1)) as FeedForwardNeuralNetwork
		
		let learningRuleGenes = [Bool](chromosome[0..<learningRuleSize])
		let learningRule = ChalmersLearningRule(bits: learningRuleGenes)
		learningRule.trainNetwork(&network, task: task, numberOfTimes: numberOfTrainingEpochs)
		
		return fitnessOf(network, on: task)
	}
	
}