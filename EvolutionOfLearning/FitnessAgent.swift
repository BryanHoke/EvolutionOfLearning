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
		let error = network.testOnTask(task)
		let fitness = 1.0 - (error / Double(task.patterns.count))
		return fitness
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
			sum + self.bitsPerWeight * task.width
		}
	}
	
	func fitnessOf(chromosome: Chromosome, on task: Task) -> Double {
		guard let taskId = task.id,
		tail = geneMap[taskId] else {
			return 0
		}
		var loc = 0
		if let prevIdx = geneMap.previousValueForKey(taskId) {
			loc = prevIdx
		}
		var genes: [Bool] = []
		genes.appendContentsOf(chromosome[loc..<tail])
		
		return 0
	}
	
}

struct ExtendedChalmersFitnessAgent: FitnessAgent {
	
	let bitsPerWeight = 3
	
	let exponentialCap = 4
	
	let learningRuleSize = 35
	
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
			sum + self.bitsPerWeight * task.width
		}
	}
	
	func fitnessOf(chromosome: Chromosome, on task: Task) -> Double {
		
		return 0
	}
	
}