//
//  TrialStatisticsFileWriter.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/24/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

struct TrialStatisticsFileWriter<Record : TrialRecord> {
	
	typealias IndividualType = Record.IndividualType
	
	typealias PopulationType = Population<IndividualType>
	
	let baseFilename = "Stats"
	
	let fileExtension = ".csv"
	
	func persist(record: Record, withIndex index: Int, inDirectory directoryPath: String) {
		let content = makeFileContent(for: record)
		let path = "\(directoryPath)/\(baseFilename) \(index)\(fileExtension)"
		do {
			try content.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
		}
		catch let error as NSError {
			preconditionFailure("\(error)")
		}
	}
	
	func makeFileContent(for record: Record) -> String {
		return "GEN, AVG, MAX\n"
			+ record.evaluations.map(makeFileContent(for:)).joinWithSeparator("\n\n")
	}
	
	func makeFileContent(for evaluation: AnyEvaluationRecord<IndividualType>) -> String {
		return evaluation.populations.enumerate().map({ makeFileContent(for: $0.1, generation: $0.0) }).joinWithSeparator("\n")
	}
	
	func makeFileContent(for population: PopulationType, generation: Int) -> String {
		return "\(generation), \(population.averageFitness), \(population[0].fitness)"
	}
	
}
