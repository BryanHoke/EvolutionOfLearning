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
		return mapping.lastValue?.endIndex ?? offset
	}
	
	var mapping = IndexedDictionary<Int, Range<Int>>()
	
	public mutating func addMapping(`for` task: Task) {
		guard let index = task.id else {
			return assertionFailure("Expect tasks to have an id")
		}
		let start = chromosomeSize
		let end = start + geneLength(of: task)
		mapping[index] = start..<end
	}
	
	public func geneRange(of task: Task) -> Range<Int>? {
		guard let index = task.id else {
			preconditionFailure("Expect task to have an id")
		}
		return mapping[index]
	}
	
	private func geneLength(of task: Task) -> Int {
		return bitsPerWeight * task.width
	}
	
}