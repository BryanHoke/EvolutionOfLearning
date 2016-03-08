//
//  Individual.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/27/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation


public typealias IndividualPair = (Individual, Individual)


///
public protocol GeneticIndividual {
	
	var chromosome: Chromosome { get }
	
	var fitness: Double { get set }
	
	var id: NSUUID { get }
	
	var parentID1: NSUUID? { get }
	
	var parentID2: NSUUID? { get }
}

public func crossover(individual1: Individual, individual2: Individual,  crossoverOperator: CrossoverOperator) -> IndividualPair {
	let offspringChromosomes = crossoverOperator(individual1.chromosome, individual2.chromosome)
	var offspring = (Individual(chromosome: offspringChromosomes.0), Individual(chromosome: offspringChromosomes.1))
	offspring.0.parentID1 = individual1.id
	offspring.0.parentID2 = individual2.id
	offspring.1.parentID1 = individual1.id
	offspring.1.parentID2 = individual2.id
	return offspring
}

public func mutate(individual: Individual, mutationOperator: MutationOperator) -> Individual {
	let offspringChromosome = mutationOperator(individual.chromosome)
	var offspring = Individual(chromosome: offspringChromosome)
	offspring.parentID1 = individual.id
	return offspring
}

public func recombine(individual1: Individual, individual2: Individual, recombinationOperator: RecombinationOperator) -> Individual {
	let offspringChromosome = recombinationOperator(individual1.chromosome, individual2.chromosome)
	var offspring = Individual(chromosome: offspringChromosome)
	offspring.parentID1 = individual1.id
	offspring.parentID2 = individual2.id
	return offspring
}

///
public struct Individual: GeneticIndividual {
	
	///
	public init(chromosome: Chromosome) {
		self.chromosome = chromosome
	}
	
	///
	public let chromosome: Chromosome
	
	///
	public var fitness: Double = 0
	
	///
	public let id = NSUUID()
	
	///
	public private(set) var parentID1: NSUUID?
	
	///
	public private(set) var parentID2: NSUUID?
	
	///
	public func reproduceWithCrossover(crossoverOperator: CrossoverOperator, pairIndividual: Individual) -> (Individual, Individual) {
		let offspringChromosomes = crossoverOperator(chromosome, pairIndividual.chromosome)
		var offspring = (Individual(chromosome: offspringChromosomes.0), Individual(chromosome: offspringChromosomes.1))
		offspring.0.parentID1 = id
		offspring.0.parentID2 = pairIndividual.id
		offspring.1.parentID1 = id
		offspring.1.parentID2 = pairIndividual.id
//		for child in [offspring.0, offspring.1] {
//			child.parentID1 = id
//			child.parentID2 = pairIndividual.id
//		}
		return offspring
	}
	
	///
	public func reproduceWithMutation(mutationOperator: MutationOperator) -> Individual {
		let offspringChromosome = mutationOperator(chromosome)
		var offspring = Individual(chromosome: offspringChromosome)
		offspring.parentID1 = id
		return offspring
	}
	
	///
	public func reproduceWithRecombination(recombinationOperator: RecombinationOperator, pairIndividual: Individual) -> Individual {
		let offspringChromosome = recombinationOperator(chromosome, pairIndividual.chromosome)
		var offspring = Individual(chromosome: offspringChromosome)
		offspring.parentID1 = id
		offspring.parentID2 = pairIndividual.id
		return offspring
	}
}


public func <(left: Individual, right: Individual) -> Bool {
	return left.fitness < right.fitness
}

public func >(left: Individual, right: Individual) -> Bool {
	return left.fitness > right.fitness
}