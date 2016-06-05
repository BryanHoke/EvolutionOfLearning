//
//  BasicIndividual.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/5/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

/// A basic implementation of `Individual`.
public struct BasicIndividual<ChromosomeType : Chromosome> : Individual {
	
	public typealias IndividualPair = (BasicIndividual<ChromosomeType>, BasicIndividual<ChromosomeType>)
	
	public typealias CrossoverOperator = (ChromosomeType, ChromosomeType) -> (ChromosomeType, ChromosomeType)
	
	public typealias MutationOperator = (ChromosomeType) -> ChromosomeType
	
	public typealias RecombinationOperator = (ChromosomeType, ChromosomeType) -> ChromosomeType
	
	public static func clone(individual: BasicIndividual) -> BasicIndividual {
		return individual
	}
	
	public static func crossover(pair: IndividualPair, using operator: CrossoverOperator) -> IndividualPair {
		let offspringChromosomes = `operator`(pair.0.chromosome, pair.1.chromosome)
		return (BasicIndividual<ChromosomeType>(chromosome: offspringChromosomes.0), BasicIndividual<ChromosomeType>(chromosome: offspringChromosomes.1))
	}
	
	public static func mutate(individual: BasicIndividual, using operator: MutationOperator) -> BasicIndividual {
		let offspringChromosome = `operator`(individual.chromosome)
		return BasicIndividual<ChromosomeType>(chromosome: offspringChromosome)
	}
	
	public static func recombine(pair: IndividualPair, using operator: RecombinationOperator) -> BasicIndividual {
		let offspringChromosome = `operator`(pair.0.chromosome, pair.1.chromosome)
		return BasicIndividual(chromosome: offspringChromosome)
	}
	
	public var chromosome: ChromosomeType
	
	public var fitness: Double = 0
	
	public init(chromosome: ChromosomeType) {
		self.chromosome = chromosome
	}
	
	public func clone() -> BasicIndividual {
		return self
	}
	
}
