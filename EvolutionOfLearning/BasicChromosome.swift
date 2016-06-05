//
//  BasicChromosome.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/4/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct BasicChromosome : Chromosome {
	
	public var genes: [Bool] = []
	
	public init(genes: [Bool]) {
		self.genes = genes
	}
	
	public init(size: Int, seed: () -> Bool) {
		genes = (0..<size).map { _ in
			seed()
		}
	}
	
}

extension BasicChromosome {

	public static func mutate(inout chromosome: BasicChromosome, withRate mutationRate: Double, usingSeed seed: Int) {
		chromosome.mutate(withRate: mutationRate, usingSeed: seed)
	}
	
	public static func mutate(inout chromosome: BasicChromosome, withRate mutationRate: Double) {
		mutate(&chromosome, withRate: mutationRate, usingSeed: Int(arc4random()))
	}

}

// MARK: - Computed Properties

extension BasicChromosome : Hashable {
	
	public var hashValue: Int {
		return stringValue.hashValue
	}
	
	public var stringValue: String {
		return genes.reduce("") { $0 + ($1 ? "1" : "0") }
	}
	
}

// MARK: - Instance Methods

extension BasicChromosome {
	
	public func mutateAtIndices(mutationIndices: Set<Int>) -> BasicChromosome {
		var mutant = self
		mutant.mutateInPlaceAtIndices(mutationIndices)
		return mutant
	}
	
	public func mutateAtIndex(index: Int) -> BasicChromosome {
		var mutant = self
		mutant.mutateInPlaceAtIndex(index)
		return mutant
	}
	
	public func mutateWithRate(mutationRate: Double, seed: Int = Int(arc4random())) -> BasicChromosome {
		var mutant = self
		mutant.mutate(withRate: mutationRate, usingSeed: seed)
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
	public mutating func mutate(withRate mutationRate: Double, usingSeed seed: Int) {
		var mutationIndices = Set<Int>()
		srand48(seed)
		for index in indices {
			if drand48() < mutationRate {
				mutationIndices.insert(index)
			}
		}
		mutateInPlaceAtIndices(mutationIndices)
	}
	
	public mutating func mutate(withRate mutationRate: Double) {
		mutate(withRate: mutationRate, usingSeed: Int(arc4random()))
	}
	
	/// Returns the offspring of a two-point crossover operation between this `Chromosome` and a pair `Chromosome`.
	///
	/// - note: The number of genes crossed-over is in the range `1..<count`. I.e., the two points may be equal and will never span the length of the `Chromosome`.
	public func twoPointCrossoverWithChromosome(pairChromosome: BasicChromosome) -> (BasicChromosome, BasicChromosome) {
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
	public func twoPointCrossoverWithChromosome(pairChromosome: BasicChromosome, seed: UInt32) -> (BasicChromosome, BasicChromosome) {
		srand(seed)
		// Generate a start locus in the range 0..<(count - 1)
		let start = Int(rand()) % (count - 1)
		
		let end = twoPointCrossoverEndLocusForStartLocus(start, randomGenerator: { (rangeSpan: UInt32) -> Int in
			return Int(rand()) % Int(rangeSpan)
		})
		
		return twoPointCrossoverWithChromosome(pairChromosome, range: start...end)
	}
	
	/// Returns the offspring of a two-point crossover operation between this `Chromosome` and a pair `Chromosome`, using a specified range defined by the two points of crossover
	public func twoPointCrossoverWithChromosome(pairChromosome: BasicChromosome, range: Range<Int>) -> (BasicChromosome, BasicChromosome) {
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

// MARK: - GeneticOperating

extension BasicChromosome {
	
	public static func mutation(mutationRate: Double) -> (BasicChromosome) -> BasicChromosome {
		return { chromosome in
			chromosome.mutateWithRate(mutationRate)
		}
	}
	
	public static func twoPointCrossover(chromosome1: BasicChromosome, chromosome2: BasicChromosome) -> (BasicChromosome, BasicChromosome) {
		return chromosome1.twoPointCrossoverWithChromosome(chromosome2)
	}
	
}

// MARK: - CollectionType

extension BasicChromosome : CollectionType {
	
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
	
	public func generate() -> BasicChromosome.Generator {
		return BasicChromosome.Generator(genes)
	}
	
	public subscript(index: Int) -> Bool {
		get {
			return genes[index]
		}
		set {
			genes[index] = newValue
		}
	}
	
	public subscript(subRange: Range<Int>) -> BasicChromosome.SubSlice {
		get {
			return genes[subRange]
		}
		set {
			genes[subRange] = newValue
		}
	}
	
}

// MARK: - LiteralConvertible

extension BasicChromosome : ArrayLiteralConvertible, StringLiteralConvertible {
	
	public init(arrayLiteral elements: BasicChromosome.Element...) {
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

public func ==(lhs: BasicChromosome, rhs: BasicChromosome) -> Bool {
	return lhs.genes == rhs.genes
}

public prefix func !(chromosome: BasicChromosome) -> BasicChromosome {
	var newChromosome = chromosome
	for (i, _) in newChromosome.enumerate() {
		newChromosome.genes[i] = !newChromosome.genes[i]
	}
	return newChromosome
}
