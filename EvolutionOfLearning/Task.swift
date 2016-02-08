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
	
	/// Constructs `Task` values from the parsed data stored in a file at a given path.
	public static func tasksWithFileAtPath(path: String) throws -> [Task] {
		let fileContent = try! String(contentsOfFile: path)
		let tokens = fileContent.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
		return try Task.tasksWithTokens(tokens)
	}
	
	/// Constructs `Task` values from `String` tokens of a task representation language.
	public static func tasksWithTokens(tokens: [String]) throws -> [Task] {
		var inputs = [[[Double]]]()
		var targets = [[[Double]]]()
		var index = 0
		while index < tokens.count {
			guard let examplarCount = Int(tokens[index++]),
				let inputCount = Int(tokens[index++]),
				let taskCount = Int(tokens[index++])
				else {
					throw NSError(domain: "", code: 1, userInfo: ["index": index])
			}
			var inputVectors = [[Double]]()
			var targetVectors = [[Double]](count: taskCount, repeatedValue: [Double]())
			for _ in 0..<examplarCount {
				var inputVector = [Double]()
				for _ in 0..<inputCount {
					guard let value = Double(tokens[index++]) else {
						throw NSError(domain: "", code: 2, userInfo: ["index": index])
					}
					inputVector.append(value)
				}
				inputVectors.append(inputVector)
				for i in 0..<taskCount {
					guard let value = Double(tokens[index++]) else {
						throw NSError(domain: "", code: 3, userInfo: ["index": index])
					}
					targetVectors[i].append(value)
				}
			}
			inputs.append(inputVectors)
			targets.append(targetVectors)
		}
		return Task.tasksWithInputs(inputs, targets: targets)
	}
	
	/// Constructs `Task` values from input and target vectors.
	public static func tasksWithInputs(inputs: [[[Double]]], targets: [[[Double]]]) -> [Task] {
		var count = 0
		var tasks = [Task]()
		for (i, inputVectors) in inputs.enumerate() {
			for j in 0..<targets[i].count {
				let targetVector = targets[i][j]
				let patterns = Pattern.patternsWithInputVectors(inputVectors, targets: targetVector)
				let task = Task(id: count++, patterns: patterns)
				tasks.append(task)
			}
		}
		return tasks
	}
	
	/// The optional ID of the task, which may be useful to have in some situations.
	public var id: Int?
	
	/// The array of `Pattern` values which comprise the task's main data.
	public var patterns = [Pattern]()
	
	/// The number of inputs each `Pattern` in the task has.
	/// - note: This assumes that all patterns have the same number of inputs as the first.
	public var inputCount: Int {
		return patterns.first?.inputs.count ?? 0
	}
	
	/// The number of targets each `Pattern` in the task has.
	/// - note: This assumes that all patterns have the same number of targets as the first.
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