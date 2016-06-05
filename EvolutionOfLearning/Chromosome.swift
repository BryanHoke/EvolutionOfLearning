//
//  Chromosome.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/16/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public protocol Chromosome : CollectionType {
	
	/// Mutates a `Chromosome` with a given mutation rate and random seed.
	///
	/// - parameter mutationRate: A real-valued number between 0 and 1 (inclusive) which determines the probability of a given gene being mutated.
	/// - parameter seed: A random seed for a function that generates a real-valued number between 0 and 1 (inclusive).
	static func mutate(inout chromosome: Self, withRate mutationRate: Double)
	
	static func twoPointCrossover(chromosome1: Self, chromosome2: Self) -> (Self, Self)
	
	var genes: [Bool] { get set }
	
	init(size: Int, seed: () -> Bool)
	
	mutating func mutate(withRate mutationRate: Double)
	
	subscript(index: Int) -> Bool { get set }
	
	subscript(subRange: Range<Int>) -> ArraySlice<Bool> { get set }
	
}

// MARK: - Computed Properties

extension Chromosome {
	
	public var hashValue: Int {
		return stringValue.hashValue
	}
	
	public var stringValue: String {
		return genes.reduce("") { $0 + ($1 ? "1" : "0") }
	}
	
}


