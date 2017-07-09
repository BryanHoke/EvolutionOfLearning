//
//  SegmentedChromosome.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/5/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

/// A `Chromosome` where crossover operates at the level of whole "segments" of genes.
public struct SegmentedChromosome : Chromosome, ExpressibleByArrayLiteral {
	
	public static func twoPointCrossover(_ chromosome1: SegmentedChromosome, chromosome2: SegmentedChromosome) -> (SegmentedChromosome, SegmentedChromosome) {
		return twoPointCrossover(chromosome1, chromosome2: chromosome2, seed: { Int(arc4random()) })
	}
	
	public static func twoPointCrossover(_ chromosome1: SegmentedChromosome, chromosome2: SegmentedChromosome, seed: () -> Int) -> (SegmentedChromosome, SegmentedChromosome) {
		let segmentCount = min(chromosome1.segmentCount, chromosome2.segmentCount)
		
		// start ∈ [0, segmentCount)
		let start = seed() % segmentCount
		assert((0..<segmentCount).contains(start))
		
		// end ∈ [start, segmentCount)
		let end = start + seed() % (segmentCount - start)
		assert((start..<segmentCount).contains(end))
		
		var offspring = (chromosome1, chromosome2)
		
		for index in start...end {
			swap(&offspring.0.segments[index], &offspring.1.segments[index])
		}
		
		return offspring
	}
	
	/// The gene segments on which crossover operates.
	public var segments: [[Bool]] = []
	
	/// The number of gene segments.
	public var segmentCount: Int {
		return segments.count
	}
	
	public var genes: [Bool] {
		return segments.flatMap { $0 }
	}
	
	public init(size: Int, seed: () -> Bool) {
		self.init(segmentSizes: [size], seed: seed)
	}
	
	public init(segments: [[Bool]]) {
		self.segments = segments
	}
	
	public init(segmentSizes: [Int], seed: () -> Bool) {
		segments = segmentSizes.map { (0..<$0).map { _ in seed() } }
	}
	
	public init(arrayLiteral elements: [Bool]...) {
		segments = elements
	}
	
	public mutating func mutate(withRate mutationRate: Double) {
		mutate(withRate: mutationRate, seed: { drand48() })
	}
	
	public mutating func mutate(withRate mutationRate: Double, seed: () -> Double) {
		for index in 0..<genes.count {
			if seed() < mutationRate {
				self[index] = !self[index]
			}
		}
	}
	
	public mutating func removeFirst(_ n: Int) {
		for _ in 0..<n {
			guard var firstSegment = segments.first else { break }
			
			firstSegment.removeFirst()
			
			if firstSegment.isEmpty {
				segments.removeFirst()
			} else {
				segments[0] = firstSegment
			}
		}
	}
	
	public subscript(index: Int) -> Bool {
		get {
			return genes[index]
		}
		set {
			var index = index
			for (i, segment) in segments.enumerated() {
				if index < segment.count {
					segments[i][index] = newValue
					return
				} else {
					index -= segment.count
				}
			}
		}
	}
	
	public subscript(subRange: CountableRange<Int>) -> ArraySlice<Bool> {
		get {
			return genes[subRange]
		}
		set {
			for (index, value) in zip(subRange, newValue) {
				self[index] = value
			}
		}
	}
	
}

public prefix func !(chromosome: SegmentedChromosome) -> SegmentedChromosome {
	var newChromosome = chromosome
	for (index, gene) in newChromosome.genes.enumerated() {
		newChromosome[index] = !gene
	}
	return newChromosome
}

public func +(lhs: SegmentedChromosome, rhs: SegmentedChromosome) -> SegmentedChromosome {
	return SegmentedChromosome(segments: lhs.segments + rhs.segments)
}
