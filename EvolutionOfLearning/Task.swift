//
//  Task.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/19/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

/// A collection of `Pattern` values on which genetic individuals are evaluated based on their ability to learn the patterns.
public struct Task {
	
	/// The unique ID of the task.
	public var id: Int
	
	/// The array of `Pattern` values which comprise the task's main data.
	public var patterns = [Pattern]()
	
	/// The number of inputs each `Pattern` in the task has.
	/// - note: This assumes that all patterns have the same number of inputs as the first.
	public var inputCount: Int {
		return patterns.first?.inputs.count ?? 0
	}
	
	/// The number of targets each `Pattern` in the task has.
	public var targetCount: Int {
		return 1
	}
	
}

extension Task {
	
	/// The base width required to represent `self` on a `Chromosome`.
	var width: Int {
		return (inputCount + 1) * targetCount
	}
	
}

extension Task : CustomStringConvertible {
	
	public var description: String {
		return patterns.map({ $0.description }).joined(separator: "\n")
	}
	
}

