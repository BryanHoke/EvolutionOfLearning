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
	
	public var environment: EvolutionaryEnvironment
	
	public var onPopulationEvaluated: ((population: Population) -> Void)?
	
	public func run(forNumberOfGenerations numberOfGenerations: Int) {
		let initialPopulation = environment.makePopulation()
		evolve(initialPopulation, forNumberOfGenerations: numberOfGenerations)
	}
	
	private func evolve(population: Population, forNumberOfGenerations numberOfGenerations: Int) {
		var population = population
		for _ in 0..<numberOfGenerations {
			evolveGeneration(of: &population)
		}
	}
	
	private func evolveGeneration(inout of population: Population) {
		evaluateFitness(of: &population)
		sort(&population)
		commit(population)
		reproduce(&population)
	}
	
	private func evaluateFitness(inout of population: Population) {
		let evaluator = ConcurrentPopulationEvaluator(fitnessFunc: fitness)
		evaluator.evaluate(&population)
	}
	
	private func fitness(of chromosome: Chromosome) -> Double {
		return environment.fitness(of: chromosome)
	}
	
	private func sort(inout population: Population) {
		population.members.sortInPlace(>)
	}
	
	private func commit(population: Population) {
		onPopulationEvaluated?(population: population)
	}
	
	private func reproduce(inout population: Population) {
		population = environment.reproduce(population)
	}
	
}
