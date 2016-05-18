//
//  ExperimentRecorder.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/17/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

final class ExperimentRecorder {
	
	var resultsBasePath: String {
		return "/Users/bryanhoke/Projects/BDHSoftware/EvolutionOfLearning/Results/"
	}
	
	private var resultsDirectory: String!
	
	func recordNewExperiment(with config: ExperimentConfig) {
		resultsDirectory = makeResultsDirectory()
		
	}
	
	func makeResultsDirectory() -> String {
		let path = pathForResults()
		do {
		try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: false, attributes: nil)
		}
		catch let error as NSError {
			preconditionFailure("Could not create results directory: \(error)")
		}
		return path
	}
	
	func pathForResults() -> String {
		var index = 0
		var path = ""
		let fileManager = NSFileManager()
		var shouldUsePath = false
		
		while !shouldUsePath {
			path = resultsDirectoryName(withIndex: index)
			shouldUsePath = !fileManager.fileExistsAtPath(path)
			index += 1
		}
		
		return path
	}
	
	func resultsDirectoryName(withIndex index: Int) -> String {
		return resultsBasePath + "Experiment \(index)"
	}
	
}
