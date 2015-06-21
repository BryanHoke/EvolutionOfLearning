//
//  Chromosome.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/16/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

public struct Chromosome: ArrayLiteralConvertible, StringLiteralConvertible, CollectionType, Hashable {
	
	public class ChromosomeGenerator: GeneratorType {
		
		public typealias Element = Bool
		
		public typealias SubSlice = ArraySlice<Element>
		
		private var index = 0
		
		private var genes: [Bool]
		
		init(genes: [Bool]) {
			self.genes = genes
		}
		
		public func next() -> ChromosomeGenerator.Element? {
			return index < genes.endIndex ? genes[index++] : nil
		}
		
	}

	public typealias Element = Bool
	
	public typealias Index = Int
	
	public typealias Generator = ChromosomeGenerator
	
	public init(arrayLiteral elements: Chromosome.Element...) {
		self.genes += elements
	}
	
	public init(unicodeScalarLiteral value: String) {
		self.genes = value.characters.map { $0 != "0" }
	}
	
	public init(extendedGraphemeClusterLiteral value: String) {
		self.genes = value.characters.map { $0 != "0" }
	}
	
	public init(stringLiteral value: String) {
		self.genes = value.characters.map { $0 != "0" }
	}
	
	public var genes = [Bool]()
	
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
	
	public var stringValue: String {
		return genes.reduce("") { $0 + ($1 ? "1" : "0") }
	}
	
	public var hashValue: Int {
		return stringValue.hashValue
	}
	
	public subscript(index: Int) -> Bool {
		get {
			return self.genes[index]
		}
		set {
			self.genes[index] = newValue
		}
	}
	
//	public subscript(subRange: Range<Int>) -> Chromosome.SubSlice {
//		get {
//			return self.genes[subRange]
//		}
//		set {
//			self.genes[subRange] = newValue
//		}
//	}
	
	public mutating func mutateAtIndices(mutationIndices: Set<Int>) {
		for index in mutationIndices {
			self.mutateAtIndex(index)
		}
	}
	
	public mutating func mutateAtIndex(index: Int) {
		self[index] = !self[index]
	}
	
	/// Mutates the `Chromosome` with a given mutation rate and random seed.
	/// - parameter mutationRate A real-valued number between 0 and 1 (inclusive) which determines the probability of a given gene being mutated.
	/// - parameter seed A random seed for a function that generates a real-valued number between 0 and 1 (inclusive).
	public mutating func mutateWithRate(mutationRate: Double, seed: Int = Int(arc4random())) {
		var mutationIndices = Set<Int>()
		srand48(seed)
		for (index, _) in enumerate() {
			if drand48() >= mutationRate {
				mutationIndices.insert(index)
			}
		}
		mutateAtIndices(mutationIndices)
	}
	
	public func twoPointCrossoverWithChromosome(pairChromosome: Chromosome) -> (Chromosome, Chromosome) {
		let start = Int(arc4random_uniform(UInt32(count - 1)))
		var end = Int(arc4random_uniform(UInt32(count - start))) + start
		// Prevent the entirety of both chromosomes from being crossed-over
		while start == 0 && end == (count - 1) {
			end = Int(arc4random_uniform(UInt32(count - start))) + start
		}
		return twoPointCrossoverWithChromosome(pairChromosome, atRange: start...end)
	}
	
	public func twoPointCrossoverWithChromosome(pairChromosome: Chromosome, atRange range: Range<Int>) -> (Chromosome, Chromosome) {
		var offspring = (self, pairChromosome)
		let beforeRange = 0..<range.startIndex
		let afterRange = range.endIndex..<count
		offspring.1.genes[beforeRange] = offspring.0.genes[beforeRange]
		offspring.0.genes[range] = offspring.1.genes[range]
		offspring.1.genes[afterRange] = offspring.0.genes[beforeRange]
		return offspring
	}
	
	public func generate() -> Chromosome.Generator {
		return ChromosomeGenerator(genes: genes)
	}
	
}

public func ==(lhs: Chromosome, rhs: Chromosome) -> Bool {
	return lhs.genes == rhs.genes
}