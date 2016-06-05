//
//  TrialRecordFileWriter.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/18/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

struct TrialRecordFileWriter<Record : TrialRecord> {
	
	typealias IndividualType = Record.IndividualType
	
	typealias PopulationType = Population<IndividualType>
	
	let baseFilename = "Trial"
	
	func persist(record: Record, withIndex index: Int, inDirectory directoryPath: String) {
		let content = makeFileContent(for: record)
		let path = "\(directoryPath)/\(baseFilename) \(index).txt"
		do {
			try content.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
		}
		catch let error as NSError {
			preconditionFailure("\(error)")
		}
	}
	
	func makeFileContent(for record: Record) -> String {
		return record.evaluations.map(makeFileContent(for:)).joinWithSeparator("\n\n")
	}
	
	func makeFileContent(for evaluation: AnyEvaluationRecord<IndividualType>) -> String {
		return "\(evaluation.name)\n"
		+ "Tasks: \(makeFileContent(for: evaluation.tasks))\n\n"
		+ makeFileContent(for: evaluation.populations)
	}
	
	func makeFileContent(for tasks: [Task]) -> String {
		return "Tasks: " + tasks.map({ "\($0.id)" }).joinWithSeparator(" ")
	}
	
	func makeFileContent(for populations: [PopulationType]) -> String {
		return populations.enumerate().map({
			"Population \($0.0)\n\(self.makeFileContent(for: $0.1))"
		}).joinWithSeparator("\n\n")
	}
	
	func makeFileContent(for population: PopulationType) -> String {
		return population.members.map(makeFileContent(for:)).joinWithSeparator("\n")
	}
	
	func makeFileContent(for individual: IndividualType) -> String {
		return "\(individual.fitness) \(individual.chromosome.stringValue)"
	}
	
}
