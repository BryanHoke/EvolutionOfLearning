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

public func crossover(pair: IndividualPair, using `operator`: CrossoverOperator) -> IndividualPair {
	let offspringChromosomes = `operator`(pair.0.chromosome, pair.1.chromosome)
	var offspring = (Individual(chromosome: offspringChromosomes.0), Individual(chromosome: offspringChromosomes.1))
	offspring.0.parentID1 = pair.0.id
	offspring.0.parentID2 = pair.1.id
	offspring.1.parentID1 = pair.0.id
	offspring.1.parentID2 = pair.1.id
	return offspring
}

public func mutate(individual: Individual, using `operator`: MutationOperator) -> Individual {
	let offspringChromosome = `operator`(individual.chromosome)
	var offspring = Individual(chromosome: offspringChromosome)
	offspring.parentID1 = individual.id
	return offspring
}

public func recombine(pair: IndividualPair, using `operator`: RecombinationOperator) -> Individual {
	let offspringChromosome = `operator`(pair.0.chromosome, pair.1.chromosome)
	var offspring = Individual(chromosome: offspringChromosome)
	offspring.parentID1 = pair.0.id
	offspring.parentID2 = pair.1.id
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
	
}


public func <(left: Individual, right: Individual) -> Bool {
	return left.fitness < right.fitness
}

public func >(left: Individual, right: Individual) -> Bool {
	return left.fitness > right.fitness
}