//
//  TrialRecordFileWriter.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/18/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

struct TrialRecordFileWriter {
	
	let baseFilename = "Trial"
	
	func persist(record: TrialRecord, withIndex index: Int, inDirectory directoryPath: String) {
		let content = makeFileContent(for: record)
		let path = "\(directoryPath)/\(baseFilename) \(index).txt"
		do {
			try content.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
		}
		catch let error as NSError {
			preconditionFailure("\(error)")
		}
	}
	
	func makeFileContent(for record: TrialRecord) -> String {
		return record.evaluations.map(makeFileContent(for:)).joinWithSeparator("\n\n")
	}
	
	func makeFileContent(for evaluation: EvaluationRecord) -> String {
		return "\(evaluation.name)\n"
		+ "Tasks: \(makeFileContent(for: evaluation.tasks))\n\n"
		+ makeFileContent(for: evaluation.populations)
	}
	
	func makeFileContent(for tasks: [Task]) -> String {
		return "Tasks: " + tasks.map({ "\($0.id)" }).joinWithSeparator(" ")
	}
	
	func makeFileContent(for populations: [Population]) -> String {
		return populations.enumerate().map({
			"Population \($0.0)\n\(self.makeFileContent(for: $0.1))"
		}).joinWithSeparator("\n\n")
	}
	
	func makeFileContent(for population: Population) -> String {
		return population.members.map(makeFileContent(for:)).joinWithSeparator("\n")
	}
	
	func makeFileContent(for individual: Individual) -> String {
		return "\(individual.fitness) \(individual.chromosome.stringValue)"
	}
	
}
