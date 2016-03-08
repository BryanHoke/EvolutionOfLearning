//
//  Chromosome.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/16/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public typealias MutationOperator = Chromosome -> Chromosome

public typealias RecombinationOperator = (Chromosome, Chromosome) -> Chromosome

public typealias CrossoverOperator = (Chromosome, Chromosome) -> (Chromosome, Chromosome)


public struct Chromosome {
	
	public init(genes: [Bool]) {
		self.genes = genes
	}
	
	public init(size: Int, seed: () -> Bool) {
		genes = (0..<size).map { _ in
			seed()
		}
	}
	
	public var genes: [Bool] = []
	
}

// MARK: - Computed Properties

extension Chromosome: Hashable {
	
	public var hashValue: Int {
		return stringValue.hashValue
	}
	
	public var stringValue: String {
		return genes.reduce("") { $0 + ($1 ? "1" : "0") }
	}
	
}

// MARK: - Instance Methods

extension Chromosome {
	
	public func mutateAtIndices(mutationIndices: Set<Int>) -> Chromosome {
		var mutant = self
		mutant.mutateInPlaceAtIndices(mutationIndices)
		return mutant
	}
	
	public func mutateAtIndex(index: Int) -> Chromosome {
		var mutant = self
		mutant.mutateInPlaceAtIndex(index)
		return mutant
	}
	
	public func mutateWithRate(mutationRate: Double, seed: Int = Int(arc4random())) -> Chromosome {
		var mutant = self
		mutant.mutateInPlaceWithRate(mutationRate, seed: seed)
		return mutant
	}
	
	public mutating func mutateInPlaceAtIndices(mutationIndices: Set<Int>) {
		for index in mutationIndices {
			mutateInPlaceAtIndex(index)
		}
	}
	
	public mutating func mutateInPlaceAtIndex(index: Int) {
		self[index] = !self[index]
	}
	
	/// Mutates the `Chromosome` with a given mutation rate and random seed.
	///
	/// - parameter mutationRate: A real-valued number between 0 and 1 (inclusive) which determines the probability of a given gene being mutated.
	/// - parameter seed: A random seed for a function that generates a real-valued number between 0 and 1 (inclusive).
	public mutating func mutateInPlaceWithRate(mutationRate: Double, seed: Int = Int(arc4random())) {
		var mutationIndices = Set<Int>()
		srand48(seed)
		for (index, _) in enumerate() {
			if drand48() < mutationRate {
				mutationIndices.insert(index)
			}
		}
		mutateInPlaceAtIndices(mutationIndices)
	}
	
	/// Returns the offspring of a two-point crossover operation between this `Chromosome` and a pair `Chromosome`.
	///
	/// - note: The number of genes crossed-over is in the range `1..<count`. I.e., the two points may be equal and never span the length of the `Chromosome`.
	public func twoPointCrossoverWithChromosome(pairChromosome: Chromosome) -> (Chromosome, Chromosome) {
		// Generate a start point in the range 0..<(count - 1)
		let start = Int(arc4random_uniform(UInt32(count - 1)))
		
		// Generate an end point in the range (start + 1)..<count
		let end = twoPointCrossoverEndLocusForStartLocus(start, randomGenerator: { (rangeSpan: UInt32) -> Int in
			return Int(arc4random_uniform(rangeSpan))
		})
		
		return twoPointCrossoverWithChromosome(pairChromosome, range: start...end)
	}
	
	/// Returns the offspring of a two-point crossover operation between this `Chromosome` and a pair `Chromosome`, using a specified random seed to generate the crossover points.
	///
	/// - note: The number of genes crossed-over is in the range `1..<count`. I.e., the two points may be equal and never span the length of the `Chromosome`.
	public func twoPointCrossoverWithChromosome(pairChromosome: Chromosome, seed: UInt32) -> (Chromosome, Chromosome) {
		srand(seed)
		// Generate a start locus in the range 0..<(count - 1)
		let start = Int(rand()) % (count - 1)
		
		let end = twoPointCrossoverEndLocusForStartLocus(start, randomGenerator: { (rangeSpan: UInt32) -> Int in
			return Int(rand()) % Int(rangeSpan)
		})
		
		return twoPointCrossoverWithChromosome(pairChromosome, range: start...end)
	}
	
	/// Returns the offspring of a two-point crossover operation between this `Chromosome` and a pair `Chromosome`, using a specified range defined by the two points of crossover
	public func twoPointCrossoverWithChromosome(pairChromosome: Chromosome, range: Range<Int>) -> (Chromosome, Chromosome) {
		var offspring = (self, pairChromosome)
		
		offspring.0.genes[range] = pairChromosome.genes[range]
		offspring.1.genes[range] = genes[range]
		
		assert(offspring.0.count == count)
		assert(offspring.1.count == pairChromosome.count)
		
		return offspring
	}
	
	/// Returns a point in the range `start..<count`, unless `start == 0` in which case the range is `start..<(count - 1)`.
	///
	/// - parameter randomGenerator: Generates an `Int` in the range `0..<$0`.
	private func twoPointCrossoverEndLocusForStartLocus(start: Int, randomGenerator: UInt32 -> Int) -> Int {
		var rangeSpan = UInt32(count - start)
		// Make sure the entire chromosome isn't crossed-over
		if start == 0 {
			rangeSpan -= 1
		}
		
		let randomIndex = randomGenerator(rangeSpan)
		let end = randomIndex + start
		
		assert(end < count)
		
		return end
	}
	
}

// MARK: - Type Methods

extension Chromosome {
	
	public static func mutation(mutationRate: Double) -> Chromosome -> Chromosome {
		return { chromosome in
			chromosome.mutateWithRate(mutationRate)
		}
	}
	
	public static func twoPointCrossover(chromosome1: Chromosome, chromosome2: Chromosome) -> (Chromosome, Chromosome) {
		return chromosome1.twoPointCrossoverWithChromosome(chromosome2)
	}
	
}

// MARK: - CollectionType

extension Chromosome: CollectionType {

	public typealias Element = Bool
	
	public typealias Index = Int
	
	public typealias Generator = IndexingGenerator<[Bool]>
	
	public typealias SubSlice = ArraySlice<Bool>
	
	public var count: Int {
		return genes.count
	}
	
	public var endIndex: Int {
		return genes.endIndex
	}
	
	public var first: Bool? {
		return genes.first
	}
	
	public var isEmpty: Bool {
		return genes.isEmpty
	}
	
	public var startIndex: Int {
		return 0
	}
	
	public func generate() -> Chromosome.Generator {
		return Chromosome.Generator(genes)
	}
	
	public subscript(index: Int) -> Bool {
		get {
			return genes[index]
		}
		set {
			genes[index] = newValue
		}
	}
	
	public subscript(subRange: Range<Int>) -> Chromosome.SubSlice {
		get {
			return genes[subRange]
		}
		set {
			genes[subRange] = newValue
		}
	}
	
}

// MARK: - LiteralConvertible

extension Chromosome: ArrayLiteralConvertible, StringLiteralConvertible {
	
	public init(arrayLiteral elements: Chromosome.Element...) {
		genes = elements
	}
	
	public init(unicodeScalarLiteral value: String) {
		genes = value.characters.map { $0 != "0" }
	}
	
	public init(extendedGraphemeClusterLiteral value: String) {
		genes = value.characters.map { $0 != "0" }
	}
	
	public init(stringLiteral value: String) {
		genes = value.characters.map { $0 != "0" }
	}
	
}

// MARK: - Operators

public func ==(lhs: Chromosome, rhs: Chromosome) -> Bool {
	return lhs.genes == rhs.genes
}

public prefix func !(chromosome: Chromosome) -> Chromosome {
	var newChromosome = chromosome
	for (i, _) in newChromosome.enumerate() {
		newChromosome.genes[i] = !newChromosome.genes[i]
	}
	return newChromosome
}