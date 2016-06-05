//
//  SegmentedChromosome.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/5/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

/// A `Chromosome` where crossover operates at the level of whole "segments" of genes.
public struct SegmentedChromosome : Chromosome {
	
	public static func twoPointCrossover(chromosome1: SegmentedChromosome, chromosome2: SegmentedChromosome) -> (SegmentedChromosome, SegmentedChromosome) {
		return twoPointCrossover(chromosome1, chromosome2: chromosome2, seed: { Int(arc4random()) })
	}
	
	public static func twoPointCrossover(chromosome1: SegmentedChromosome, chromosome2: SegmentedChromosome, seed: () -> Int) -> (SegmentedChromosome, SegmentedChromosome) {
		let segmentCount = min(chromosome1.segmentCount, chromosome2.segmentCount)
		
		// start ∈ 0..<(segmentCount - 1)
		let start = seed() % (segmentCount - 1)
		assert((0..<(segmentCount - 1)).contains(start))
		
		// end ∈ (start + 1)..<segmentCount
		let end = start + seed() % (segmentCount - start)
		assert(((start + 1)..<segmentCount).contains(end))
		
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
		let segment = (0..<size).map { _ in seed() }
		segments = [segment]
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
	
	public subscript(index: Int) -> Bool {
		get {
			return genes[index]
		}
		set {
			var index = index
			for (i, segment) in segments.enumerate() {
				if index < segment.count {
					segments[i][index] = newValue
					return
				} else {
					index -= segment.count
				}
			}
		}
	}
	
	public subscript(subRange: Range<Int>) -> ArraySlice<Bool> {
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
