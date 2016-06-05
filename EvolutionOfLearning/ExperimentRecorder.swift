//
//  ExperimentRecorder.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/17/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

final class ExperimentRecorder<Record : TrialRecord> {
	
	init() {}
	
	let resultsBasePath = "/Users/bryanhoke/Projects/BDHSoftware/OS X/EvolutionOfLearning/Results/"
	
	var resultsDirectory: String?
	
	var overview = ExperimentOverview<Record>()
	
	func createResultsDirectory() {
		makeResultsDirectory()
		do {
			try NSFileManager.defaultManager().createDirectoryAtPath(resultsDirectory!, withIntermediateDirectories: false, attributes: nil)
		}
		catch let error as NSError {
			print(error)
			preconditionFailure()
		}
	}
	
	func write(config: ExperimentConfig) {
		guard let resultsDirectory = self.resultsDirectory else {
			preconditionFailure()
		}
		ConfigFileWriter().write(config, inDirectory: resultsDirectory)
	}
	
	func write(trial: Record, withIndex index: Int) {
		guard let resultsDirectory = self.resultsDirectory else {
			preconditionFailure()
		}
		overview.accumulate(trial)
		TrialRecordFileWriter().persist(trial, withIndex: index, inDirectory: resultsDirectory)
		TrialStatisticsFileWriter().persist(trial, withIndex: index, inDirectory: resultsDirectory)
	}
	
	func writeOverview() {
		guard let resultsDirectory = self.resultsDirectory else {
			preconditionFailure()
		}
		ExperimentOverviewFileWriter().persist(overview, inDirectory: resultsDirectory)
	}
	
	func makeResultsDirectory() {
		var index = 0
		var path = ""
		let fileManager = NSFileManager()
		var shouldUsePath = false
		
		while !shouldUsePath {
			path = resultsBasePath + "Experiment \(index)"
			shouldUsePath = !fileManager.fileExistsAtPath(path)
			index += 1
		}
		
		resultsDirectory = path
	}
	
}
