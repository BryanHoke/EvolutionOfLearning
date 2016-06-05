//
//  ExperimentOverviewFileWriter.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/24/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

typealias StatPair = (averages: [Double], maximums: [Double])

struct ExperimentOverviewFileWriter<Record : TrialRecord> {
	
	typealias Overview = ExperimentOverview<Record>
	
	let baseFilename = "Overview"
	
	let fileExtension = ".csv"
	
	func persist(overview: Overview, inDirectory directoryPath: String) {
		let content = makeFileContent(for: overview)
		let path = "\(directoryPath)/\(baseFilename)\(fileExtension)"
		do {
			try content.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
		}
		catch let error as NSError {
			preconditionFailure("\(error)")
		}
	}
	
	func makeFileContent(for overview: Overview) -> String {
		let averages = overview.meanAverageFitnesses
		let maximums = overview.meanMaximumFitnesses
		return "GEN, AVG, MAX\n"
			+ makeFileContent(forMeans: (averages: averages, maximums: maximums))
		
	}
	
	func makeFileContent(forMeans means: (averages: [[Double]], maximums: [[Double]])) -> String {
		var content = ""
		let count = means.averages.count
		
		for i in 0..<count {
			let pair = (averages: means.averages[i], maximums: means.maximums[i])
			content += makeFileContent(for: pair) + "\n\n"
		}
		
		return content
	}
	
	func makeFileContent(for pair: StatPair) -> String {
		let count = pair.averages.count
		return (0..<count).map({ "\($0), \(pair.averages[$0]), \(pair.maximums[$0])" }).joinWithSeparator("\n")
	}
	
}
