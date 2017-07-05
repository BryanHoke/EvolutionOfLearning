//
//  Chromosome.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/16/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public protocol Chromosome {
	
	static func twoPointCrossover(_ chromosome1: Self, chromosome2: Self) -> (Self, Self)
	
	var genes: [Bool] { get }
	
	init(size: Int, seed: () -> Bool)
	
	init(segmentSizes: [Int], seed: () -> Bool)
	
	/// Mutates `self` with a given mutation rate and random seed.
	///
	/// - parameter mutationRate: A real-valued number between 0 and 1 (inclusive) which determines the probability of a given gene being mutated.
	/// - parameter seed: A random seed for a function that generates a real-valued number between 0 and 1 (inclusive).
	mutating func mutate(withRate mutationRate: Double)
	
	/// Removes the specified number of genes from the beginning of the chromosome.
	mutating func removeFirst(_ n: Int)
	
	subscript(index: Int) -> Bool { get set }
	
	subscript(subRange: Range<Int>) -> ArraySlice<Bool> { get set }
	
	func +(lhs: Self, rhs: Self) -> Self
	
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


