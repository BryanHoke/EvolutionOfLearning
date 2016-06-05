//
//  Individual.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/27/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation


//public typealias IndividualPair = (Individual, Individual)


///
public protocol Individual : Comparable {
	
	associatedtype ChromosomeType : Chromosome
	
	var chromosome: ChromosomeType { get set }
	
	var fitness: Double { get set }
	
	init(chromosome: ChromosomeType)
	
	static func clone(individual: Self) -> Self
	
	static func crossover(pair: (Self, Self), using operator: (ChromosomeType, ChromosomeType) -> (ChromosomeType, ChromosomeType)) -> (Self, Self)
	
	static func mutate(individual: Self, using operator: (ChromosomeType) -> ChromosomeType) -> Self
	
	static func recombine(pair: (Self, Self), using operator: (ChromosomeType, ChromosomeType) -> ChromosomeType) -> Self
	
	func clone() -> Self
	
}

public func <<IndividualType : Individual>(left: IndividualType, right: IndividualType) -> Bool {
	return left.fitness < right.fitness
}

public func ==<IndividualType : Individual>(left: IndividualType, right: IndividualType) -> Bool {
	return left.fitness == right.fitness
}

public func ><IndividualType : Individual>(left: IndividualType, right: IndividualType) -> Bool {
	return left.fitness > right.fitness
}

///
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
	public let id = NSUUID()
	
	///
	public private(set) var parentID1: NSUUID?
	
	///
	public private(set) var parentID2: NSUUID?
	
	public static func clone(individual: IdentifiedIndividual) -> IdentifiedIndividual {
		var offspring = IdentifiedIndividual(chromosome: individual.chromosome)
		offspring.inheritParentID(of: individual)
		return offspring
	}
	
	public static func crossover(pair: IndividualPair, using operator: CrossoverOperator) -> IndividualPair {
		let offspringChromosomes = `operator`(pair.0.chromosome, pair.1.chromosome)
		var offspring = (IdentifiedIndividual<ChromosomeType>(chromosome: offspringChromosomes.0), IdentifiedIndividual<ChromosomeType>(chromosome: offspringChromosomes.1))
		offspring.0.inhereritParentIDs(of: pair)
		offspring.1.inhereritParentIDs(of: pair)
		return offspring
	}
	
	public static func mutate(individual: IdentifiedIndividual, using operator: MutationOperator) -> IdentifiedIndividual {
		let offspringChromosome = `operator`(individual.chromosome)
		var offspring = IdentifiedIndividual<ChromosomeType>(chromosome: offspringChromosome)
		offspring.parentID1 = individual.id
		return offspring
	}
	
	public static func recombine(pair: IndividualPair, using operator: RecombinationOperator) -> IdentifiedIndividual {
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
