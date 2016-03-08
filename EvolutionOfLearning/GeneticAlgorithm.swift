//
//  GeneticAlgorithm.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/23/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public typealias FitnessFunc = Chromosome -> Double

public typealias PopulationFitnessFunc = inout Population -> ()

public struct GeneticAlgorithm {
	
	public let environment: EvolutionaryEnvironment
	
	public let onPopulationEvaluated: ((population: Population) -> Void)?
	
	public func run(forGenerations numberOfGenerations: Int, populationSize: Int, initialPopulation: Population? = nil) {
		var population = initialPopulation ?? makePopulation(size: populationSize)
		runGenerations(of: &population, numberOfGenerations: numberOfGenerations)
	}
	
	private func makePopulation(size size: Int) -> Population {
		return environment.makePopulation(size: size)
	}
	
	private func runGenerations(inout of population: Population, numberOfGenerations: Int) {
		for _ in 0..<numberOfGenerations {
			runGeneration(of: &population)
		}
	}
	
	private func runGeneration(inout of population: Population) {
		evaluateFitness(of: &population)
		commit(&population)
		reproduce(&population)
	}
	
	private func evaluateFitness(inout of population: Population) {
		let blocks = makeDispatchBlocks(forEvaluating: &population)
		concurrentlyDispatch(blocks, priority: DISPATCH_QUEUE_PRIORITY_HIGH)
	}
	
	private func makeDispatchBlocks(inout forEvaluating population: Population) -> [dispatch_block_t] {
		return population.indices.map { index -> dispatch_block_t in
			self.makeBlockToEvaluateFitness(of: &population[index])
		}
	}
	
	private func makeBlockToEvaluateFitness(inout of member: Individual) -> dispatch_block_t {
		return {
			self.evaluateFitness(of: &member)
		}
	}
	
	private func evaluateFitness(inout of member: Individual) {
		let chromosome = member.chromosome
		member.fitness = fitness(of: chromosome)
	}
	
	private func fitness(of chromosome: Chromosome) -> Double {
		return environment.fitness(of: chromosome)
	}
	
	private func commit(inout population: Population) {
		population.members.sortInPlace(>)
		onPopulationEvaluated?(population: population)
	}
	
	private func reproduce(inout population: Population) {
		population = environment.reproduce(population)
	}
	
}
