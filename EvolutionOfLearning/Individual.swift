//
//  Individual.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/27/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

///
public protocol Individual : Comparable {
	
	associatedtype ChromosomeType : Chromosome
	
	var chromosome: ChromosomeType { get set }
	
	var fitness: Double { get set }
	
	init(chromosome: ChromosomeType)
	
	static func clone(_ individual: Self) -> Self
	
	static func crossover(_ pair: (Self, Self), using operator: (ChromosomeType, ChromosomeType) -> (ChromosomeType, ChromosomeType)) -> (Self, Self)
	
	static func mutate(_ individual: Self, using operator: (ChromosomeType) -> ChromosomeType) -> Self
	
	static func recombine(_ pair: (Self, Self), using operator: (ChromosomeType, ChromosomeType) -> ChromosomeType) -> Self
	
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
