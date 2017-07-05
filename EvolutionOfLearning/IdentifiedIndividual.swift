//
//  IdentifiedIndividual.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/5/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

/// An `Individual` with a unique `id` and the `id`s of its parents.
public struct IdentifiedIndividual<ChromosomeType : Chromosome> : Individual {
	
	public typealias IndividualPair = (IdentifiedIndividual<ChromosomeType>, IdentifiedIndividual<ChromosomeType>)
	
	public typealias CrossoverOperator = (ChromosomeType, ChromosomeType) -> (ChromosomeType, ChromosomeType)
	
	public typealias MutationOperator = (ChromosomeType) -> ChromosomeType
	
	public typealias RecombinationOperator = (ChromosomeType, ChromosomeType) -> ChromosomeType
	
	///
	public var chromosome: ChromosomeType
	
	///
	public var fitness: Double = 0
	
	///
	public let id = UUID()
	
	///
	public fileprivate(set) var parentID1: UUID?
	
	///
	public fileprivate(set) var parentID2: UUID?
	
	public static func clone(_ individual: IdentifiedIndividual) -> IdentifiedIndividual {
		var offspring = IdentifiedIndividual(chromosome: individual.chromosome)
		offspring.inheritParentID(of: individual)
		return offspring
	}
	
	public static func crossover(_ pair: IndividualPair, using operator: CrossoverOperator) -> IndividualPair {
		let offspringChromosomes = `operator`(pair.0.chromosome, pair.1.chromosome)
		var offspring = (IdentifiedIndividual<ChromosomeType>(chromosome: offspringChromosomes.0), IdentifiedIndividual<ChromosomeType>(chromosome: offspringChromosomes.1))
		offspring.0.inhereritParentIDs(of: pair)
		offspring.1.inhereritParentIDs(of: pair)
		return offspring
	}
	
	public static func mutate(_ individual: IdentifiedIndividual, using operator: MutationOperator) -> IdentifiedIndividual {
		let offspringChromosome = `operator`(individual.chromosome)
		var offspring = IdentifiedIndividual<ChromosomeType>(chromosome: offspringChromosome)
		offspring.parentID1 = individual.id
		return offspring
	}
	
	public static func recombine(_ pair: IndividualPair, using operator: RecombinationOperator) -> IdentifiedIndividual {
		let offspringChromosome = `operator`(pair.0.chromosome, pair.1.chromosome)
		var offspring = IdentifiedIndividual(chromosome: offspringChromosome)
		offspring.inhereritParentIDs(of: pair)
		return offspring
	}
	
	///
	public init(chromosome: ChromosomeType) {
		self.chromosome = chromosome
	}
	
	public func clone() -> IdentifiedIndividual {
		var offspring = IdentifiedIndividual(chromosome: chromosome)
		offspring.inheritParentID(of: self)
		return offspring
	}
	
	public mutating func inheritParentID(of individual: IdentifiedIndividual) {
		parentID1 = individual.id
	}
	
	public mutating func inhereritParentIDs(of pair: IndividualPair) {
		parentID1 = pair.0.id
		parentID2 = pair.1.id
	}
	
}
