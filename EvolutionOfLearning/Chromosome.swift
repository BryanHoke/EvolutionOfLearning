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

/**

*/
public struct Chromosome: ArrayLiteralConvertible, StringLiteralConvertible, CollectionType, Hashable {
	
	///
	public static func mutation(mutationRate: Double)(chromosome: Chromosome) -> Chromosome {
		
		return chromosome.mutateWithRate(mutationRate)
	}
	
	///
	public static func twoPointCrossover(chromosome1: Chromosome, chromosome2: Chromosome) -> (Chromosome, Chromosome) {
		
		return chromosome1.twoPointCrossoverWithChromosome(chromosome2)
	}

	public typealias Element = Bool
	
	public typealias Index = Int
	
	public typealias Generator = IndexingGenerator<[Bool]>
	
	public typealias SubSlice = ArraySlice<Bool>
	
	///
	public init(size: Int, seed: () -> Bool) {
		
		for _ in 0..<size {
			
			let gene = seed()
			
			genes.append(gene)
		}
	}
	
	///
	public init(arrayLiteral elements: Chromosome.Element...) {
		
		self.genes += elements
	}
	
	///
	public init(unicodeScalarLiteral value: String) {
		
		self.genes += value.characters.map { $0 != "0" }
	}
	
	///
	public init(extendedGraphemeClusterLiteral value: String) {
		
		self.genes += value.characters.map { $0 != "0" }
	}
	
	///
	public init(stringLiteral value: String) {
		
		self.genes += value.characters.map { $0 != "0" }
	}
	
	///
	public var genes = [Bool]()
	
	///
	public var count: Int {
		
		return genes.count
	}
	
	///
	public var endIndex: Int {
		
		return genes.endIndex
	}
	
	///
	public var first: Bool? {
		
		return genes.first
	}
	
	///
	public var isEmpty: Bool {
		
		return genes.isEmpty
	}
	
	///
	public var startIndex: Int {
		
		return 0
	}
	
	///
	public var stringValue: String {
		
		return genes.reduce("") { $0 + ($1 ? "1" : "0") }
	}
	
	///
	public var hashValue: Int {
		
		return stringValue.hashValue
	}
	
	///
	public subscript(index: Int) -> Bool {
		get {
			return self.genes[index]
		}
		set {
			self.genes[index] = newValue
		}
	}
	
	///
	public subscript(subRange: Range<Int>) -> Chromosome.SubSlice {
		get {
			return self.genes[subRange]
		}
		set {
			self.genes[subRange] = newValue
		}
	}
	
	///
	public func mutateAtIndices(mutationIndices: Set<Int>) -> Chromosome {
		var mutant = self
		mutant.mutateInPlaceAtIndices(mutationIndices)
		return mutant
	}
	
	///
	public func mutateAtIndex(index: Int) -> Chromosome {
		var mutant = self
		mutant.mutateInPlaceAtIndex(index)
		return mutant
	}
	
	///
	public func mutateWithRate(mutationRate: Double, seed: Int = Int(arc4random())) -> Chromosome {
		var mutant = self
		mutant.mutateInPlaceWithRate(mutationRate, seed: seed)
		return mutant
	}
	
	///
	public mutating func mutateInPlaceAtIndices(mutationIndices: Set<Int>) {
		for index in mutationIndices {
			self.mutateInPlaceAtIndex(index)
		}
	}

	///
	public mutating func mutateInPlaceAtIndex(index: Int) {
		self[index] = !self[index]
	}
	
	/// Mutates the `Chromosome` with a given mutation rate and random seed.
	/// - parameter mutationRate: A real-valued number between 0 and 1 (inclusive) which determines the probability of a given gene being mutated.
	/// - parameter seed: A random seed for a function that generates a real-valued number between 0 and 1 (inclusive).
	public mutating func mutateInPlaceWithRate(mutationRate: Double, seed: Int = Int(arc4random())) {
		var mutationIndices = Set<Int>()
		srand48(seed)
		for (index, _) in enumerate() {
			if drand48() >= mutationRate {
				mutationIndices.insert(index)
			}
		}
		mutateInPlaceAtIndices(mutationIndices)
	}

	///
	public func twoPointCrossoverWithChromosome(pairChromosome: Chromosome) -> (Chromosome, Chromosome) {
		let start = Int(arc4random_uniform(UInt32(count - 1)))
		let end = twoPointCrossoverEndLocusForStartLocus(start) { (rangeSpan: UInt32) -> Int in
			return Int(arc4random_uniform(rangeSpan))
		}
		return twoPointCrossoverWithChromosome(pairChromosome, atRange: start...end)
	}
	
	///
	public func twoPointCrossoverWithChromosome(pairChromosome: Chromosome, seed: UInt32) -> (Chromosome, Chromosome) {
		srand(seed)
		let start = Int(rand()) % (count - 1)
		let end = twoPointCrossoverEndLocusForStartLocus(start) { (rangeSpan: UInt32) -> Int in
			return Int(rand()) % Int(rangeSpan)
		}
		return twoPointCrossoverWithChromosome(pairChromosome, atRange: start...end)
	}
	
	///
	public func twoPointCrossoverWithChromosome(pairChromosome: Chromosome, atRange range: Range<Int>) -> (Chromosome, Chromosome) {
		var offspring = (self, pairChromosome)
		let beforeRange = 0..<range.startIndex
		let afterRange = range.endIndex..<count
		
		offspring.1.genes[beforeRange] = offspring.0.genes[beforeRange]
		offspring.0.genes[range] = offspring.1.genes[range]
		offspring.1.genes[afterRange] = offspring.0.genes[afterRange]
		
		assert(offspring.0.count == count)
		assert(offspring.1.count == pairChromosome.count)
		
		return offspring
	}
	
	///
	private func twoPointCrossoverEndLocusForStartLocus(start: Int,
		randomGenerator: (UInt32) -> (Int)) -> Int
	{
		var end: Int
		
		// Make sure the entire chromosome isn't crossed-over
		repeat {
			let rangeSpan = UInt32(count - start)
			let randomIndex = randomGenerator(rangeSpan)
			end = randomIndex + start
		} while start == 0 && end == count - 1
		
		assert(end < count)
		
		return end
	}
	
	///
	public func generate() -> Chromosome.Generator {
		return Chromosome.Generator(genes)
	}
	
}

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