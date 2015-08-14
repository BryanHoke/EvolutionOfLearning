//
//  Individual.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/27/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public typealias IndividualPair = (Individual, Individual)

public protocol GeneticIndividual {
	
	var chromosome: Chromosome { get }
	
	var fitness: Double { get set }
	
	var id: NSUUID { get }
	
}

public final class Individual: GeneticIndividual {
	
	public init(chromosome: Chromosome) {
		self.chromosome = chromosome
	}
	
	public let chromosome: Chromosome
	
	public var fitness: Double = 0
	
	public let id = NSUUID()
	
	public private(set) var parentID1: NSUUID?
	
	public private(set) var parentID2: NSUUID?
	
	public func reproduceWithCrossover(crossoverOperator: CrossoverOperator, pairIndividual: Individual) -> (Individual, Individual) {
		let offspringChromosomes = crossoverOperator(chromosome, pairIndividual.chromosome)
		let offspring = (Individual(chromosome: offspringChromosomes.0), Individual(chromosome: offspringChromosomes.1))
		for child in [offspring.0, offspring.1] {
			child.parentID1 = id
			child.parentID2 = pairIndividual.id
		}
		return offspring
	}
	
	public func reproduceWithMutation(mutationOperator: MutationOperator) -> Individual {
		let offspringChromosome = mutationOperator(chromosome)
		let offspring = Individual(chromosome: offspringChromosome)
		offspring.parentID1 = id
		return offspring
	}
	
	public func reproduceWithRecombination(recombinationOperator: RecombinationOperator, pairIndividual: Individual) -> Individual {
		let offspringChromosome = recombinationOperator(chromosome, pairIndividual.chromosome)
		let offspring = Individual(chromosome: offspringChromosome)
		offspring.parentID1 = id
		offspring.parentID2 = pairIndividual.id
		return offspring
	}
}