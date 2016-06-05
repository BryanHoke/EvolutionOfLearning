//
//  GeneticOperating.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/13/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public typealias MutationOperator = Chromosome -> Chromosome

public typealias RecombinationOperator = (Chromosome, Chromosome) -> Chromosome

public typealias CrossoverOperator = (Chromosome, Chromosome) -> (Chromosome, Chromosome)

public protocol GeneticOperating {
	
	associatedtype ChromosomeType : Chromosome
	
	func mutation(mutationRate: Double) -> ChromosomeType -> ChromosomeType
	
	func twoPointCrossover(chromosome1: ChromosomeType, chromosome2: ChromosomeType) -> (ChromosomeType, ChromosomeType)
	
}