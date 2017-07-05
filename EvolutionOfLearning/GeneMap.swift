//
//  GeneMap.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 2/26/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct GeneMap {
	
	public init(bitsPerWeight: Int, offset: Int) {
		self.bitsPerWeight = bitsPerWeight
		self.offset = offset
	}
	
	/// The number of bits each network weight is comprised of.
	public let bitsPerWeight: Int
	
	/// The number of genes that the mapping is offset from the beginning of a `Chromosome`.
	public let offset: Int
	
	public var chromosomeSize: Int {
		return mapping.lastValue?.upperBound ?? offset
	}
	
	var mapping = OrderedDictionary<Int, CountableRange<Int>>()
	
	var count: Int {
		return mapping.count
	}
	
	public mutating func addMapping(for task: Task) {
		let index = task.id
		let start = chromosomeSize
		let end = start + geneLength(of: task)
		mapping[index] = start..<end
	}
	
	public func geneRange(of task: Task) -> CountableRange<Int>? {
		let index = task.id
		return mapping[index]
	}
	
	fileprivate func geneLength(of task: Task) -> Int {
		return bitsPerWeight * task.width
	}
	
}
