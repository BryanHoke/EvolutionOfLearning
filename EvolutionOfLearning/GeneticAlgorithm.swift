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
	
	public var onPopulationEvaluated: ((_ population: PopulationType) -> Void)?
	
	public func run(forNumberOfGenerations numberOfGenerations: Int) {
		let initialPopulation = environment.makePopulation()
		evolve(initialPopulation, forNumberOfGenerations: numberOfGenerations)
	}
	
	fileprivate func evolve(_ population: PopulationType, forNumberOfGenerations numberOfGenerations: Int) {
		var population = population
		for _ in 0..<numberOfGenerations {
			evolveGeneration(of: &population)
		}
	}
	
	fileprivate func evolveGeneration(of population: inout PopulationType) {
		evaluateFitness(of: &population)
		sort(&population)
		commit(population)
		reproduce(&population)
	}
	
	fileprivate func evaluateFitness(of population: inout PopulationType) {
		let evaluator = ConcurrentPopulationEvaluator<IndividualType>(fitnessFunc: fitness)
		evaluator.evaluate(&population)
	}
	
	fileprivate func fitness(of chromosome: IndividualType.ChromosomeType) -> Double {
		return environment.fitness(of: chromosome)
	}
	
	fileprivate func sort(_ population: inout PopulationType) {
		population.members.sort(by: >)
	}
	
	fileprivate func commit(_ population: PopulationType) {
		onPopulationEvaluated?(population)
	}
	
	fileprivate func reproduce(_ population: inout PopulationType) {
		population = environment.reproduce(population)
	}
	
}
