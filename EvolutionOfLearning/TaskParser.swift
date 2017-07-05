//
//  TaskParser.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/5/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct TaskParser {
	
	/// Constructs `Task` values from the parsed data stored in a file at a given path.
	public func tasks(withFileAt path: String) throws -> [Task] {
		let fileContent = try! String(contentsOfFile: path)
		let tokens = fileContent.components(separatedBy: CharacterSet.whitespacesAndNewlines)
		return try tasks(with: tokens)
	}
	
	/// Constructs `Task` values from `String` tokens of a task representation language.
	public func tasks(with tokens: [String]) throws -> [Task] {
		var inputs: [[[Double]]] = []
		var targets: [[[Double]]] = []
		var index = 0
		
		while index < tokens.count {
			let
			examplarCount = try readInt(from: tokens, at: &index),
			inputCount = try readInt(from: tokens, at: &index),
			taskCount = try readInt(from: tokens, at: &index)
			
			var inputVectors: [[Double]] = .init(repeating: [], count: examplarCount)
			var targetVectors: [[Double]] = .init(repeating: [], count: taskCount)
			
			for examplarIndex in 0..<examplarCount {
				
				inputVectors[examplarIndex].reserveCapacity(inputCount)
				for _ in 0..<inputCount {
					let value = try readDouble(from: tokens, at: &index)
					inputVectors[examplarIndex].append(value)
				}
				
				for taskIndex in 0..<taskCount {
					let value = try readDouble(from: tokens, at: &index)
					targetVectors[taskIndex].append(value)
				}
			}
			
			inputs.append(inputVectors)
			targets.append(targetVectors)
		}
		
		return tasks(inputs: inputs, targets: targets)
	}
	
	fileprivate func readInt(from tokens: [String], at index: inout Int) throws -> Int {
		guard let intValue = Int(tokens[index]) else {
			throw NSError(domain: "", code: 1, userInfo: ["index": index])
		}
		index += 1
		return intValue
	}
	
	fileprivate func readDouble(from tokens: [String], at index: inout Int) throws -> Double {
		guard let doubleValue = Double(tokens[index]) else {
			throw NSError(domain: "", code: 2, userInfo: ["index": index])
		}
		index += 1
		return doubleValue
	}
	
	/// Constructs `Task` values from input and target vectors.
	public func tasks(inputs: [[[Double]]], targets: [[[Double]]]) -> [Task] {
		var count = 0
		var tasks: [Task] = []
		for (i, inputVectors) in inputs.enumerated() {
			for j in 0..<targets[i].count {
				let targetVector = targets[i][j]
				let patterns = Pattern.patternsWithInputVectors(inputVectors, targets: targetVector)
				let task = Task(id: count, patterns: patterns)
				count += 1
				tasks.append(task)
			}
		}
		return tasks
	}
	
}
