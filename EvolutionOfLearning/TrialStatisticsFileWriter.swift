//
//  TrialStatisticsFileWriter.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/24/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

struct TrialStatisticsFileWriter {
	
	let baseFilename = "Stats"
	
	let fileExtension = ".csv"
	
	func persist(record: TrialRecord, withIndex index: Int, inDirectory directoryPath: String) {
		let content = makeFileContent(for: record)
		let path = "\(directoryPath)/\(baseFilename) \(index)\(fileExtension)"
		do {
			try content.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
		}
		catch let error as NSError {
			preconditionFailure("\(error)")
		}
	}
	
	func makeFileContent(for record: TrialRecord) -> String {
		return "AVG, MAX\n"
			+ record.evaluations.map(makeFileContent(for:)).joinWithSeparator("\n\n")
	}
	
	func makeFileContent(for evaluation: EvaluationRecord) -> String {
		return evaluation.populations.map(makeFileContent(for:)).joinWithSeparator("\n")
	}
	
	func makeFileContent(for population: Population) -> String {
		return "\(population.averageFitness), \(population[0].fitness)"
	}
	
}
