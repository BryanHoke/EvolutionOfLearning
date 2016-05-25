//
//  ExperimentRecorder.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/17/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

final class ExperimentRecorder {
	
	init() {
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
	
	let resultsBasePath = "/Users/bryanhoke/Projects/BDHSoftware/OS X/EvolutionOfLearning/Results/"
	
	let resultsDirectory: String
	
	var overview = ExperimentOverview()
	
	func createResultsDirectory() {
		do {
			try NSFileManager.defaultManager().createDirectoryAtPath(resultsDirectory, withIntermediateDirectories: false, attributes: nil)
		}
		catch let error as NSError {
			print(error)
			preconditionFailure()
		}
	}
	
	func write(config: ExperimentConfig) {
		ConfigFileWriter().write(config, inDirectory: resultsDirectory)
	}
	
	func write(trial: TrialRecord, withIndex index: Int) {
		overview.accumulate(trial)
		TrialRecordFileWriter().persist(trial, withIndex: index, inDirectory: resultsDirectory)
		TrialStatisticsFileWriter().persist(trial, withIndex: index, inDirectory: resultsDirectory)
	}
	
	func writeOverview() {
		ExperimentOverviewFileWriter().persist(overview, inDirectory: resultsDirectory)
	}
	
	func makeResultsDirectory() {
		do {
		try NSFileManager.defaultManager().createDirectoryAtPath(resultsDirectory, withIntermediateDirectories: false, attributes: nil)
		}
		catch let error as NSError {
			preconditionFailure("Could not create results directory: \(error)")
		}
	}
	
}
