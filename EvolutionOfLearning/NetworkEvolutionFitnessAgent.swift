//
//  NetworkEvolutionFitnessAgent.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 4/10/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct NetworkEvolutionFitnessAgent<ChromosomeType : Chromosome> : FitnessAgent {
	
	public init(bitsPerWeight: Int, exponentShift: Int, tasks: [Task]) {
		self.bitsPerWeight = bitsPerWeight
		self.exponentShift = exponentShift
		self.tasks = tasks
		geneMap = GeneMap(bitsPerWeight: bitsPerWeight, offset: 0)
		buildGeneMap()
	}
	
	/// Preferred value is `3`.
	public let bitsPerWeight: Int
	
	/// Preferred value is `4`.
	private let exponentShift: Int
	
	public let tasks: [Task]
	
	private var geneMap: GeneMap
	
	private mutating func buildGeneMap() {
		for task in tasks {
			geneMap.addMapping(for: task)
		}
	}
	
	// TODO: Test
	public func seed() -> ChromosomeType {
		let sizes = geneMap.mapping.map { (mapping: (index: Int, range: Range<Int>)) -> Int in
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
		let network = makeNetwork(for: task, genes: genes)
		
		return fitness(of: network, on: task)
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
