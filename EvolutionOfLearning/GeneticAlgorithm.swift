//
//  GeneticAlgorithm.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/23/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

//public typealias FitnessFunc = Chromosome -> Double

//public typealias PopulationFitnessFunc = (inout Population) -> ()

public struct GeneticAlgorithm<EnvironmentType : Environment> {
	
	public typealias IndividualType = EnvironmentType.IndividualType
	
	public typealias PopulationType = Population<IndividualType>
	
	public var environment: EnvironmentType
	
	public var onPopulationEvaluated: ((population: PopulationType) -> Void)?
	
	public func run(forNumberOfGenerations numberOfGenerations: Int) {
		let initialPopulation = environment.makePopulation()
		evolve(initialPopulation, forNumberOfGenerations: numberOfGenerations)
	}
	
	private func evolve(population: PopulationType, forNumberOfGenerations numberOfGenerations: Int) {
		var population = population
		for _ in 0..<numberOfGenerations {
			evolveGeneration(of: &population)
		}
	}
	
	private func evolveGeneration(inout of population: PopulationType) {
		evaluateFitness(of: &population)
		sort(&population)
		commit(population)
		reproduce(&population)
	}
	
	private func evaluateFitness(inout of population: PopulationType) {
		let evaluator = ConcurrentPopulationEvaluator<IndividualType>(fitnessFunc: fitness)
		evaluator.evaluate(&population)
	}
	
	private func fitness(of chromosome: IndividualType.ChromosomeType) -> Double {
		return environment.fitness(of: chromosome)
	}
	
	private func sort(inout population: PopulationType) {
		population.members.sortInPlace(>)
	}
	
	private func commit(population: PopulationType) {
		onPopulationEvaluated?(population: population)
	}
	
	private func reproduce(inout population: PopulationType) {
		population = environment.reproduce(population)
	}
	
}
