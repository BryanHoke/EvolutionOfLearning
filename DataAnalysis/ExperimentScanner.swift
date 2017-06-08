//
//  ExperimentScanner.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 8/10/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

final class ExperimentScanner {
	
	static let shared = ExperimentScanner()
	
	func scanExperimentOverview(fromDirectoryAtPath path: String) throws -> ExperimentOverview {
		let url = URL(fileURLWithPath: path, isDirectory: true)
		return try scanExperimentOverview(fromDirectoryAt: url)
	}
	
	func scanExperimentOverview(fromDirectoryAt url: URL) throws -> ExperimentOverview {
		let trials = try scanTrials(fromDirectoryAt: url)
		
		var overview = ExperimentOverview()
		
		for trial in trials {
			overview.accumulate(trial)
		}
		
		return overview
	}
	
	fileprivate func scanTrials(fromDirectoryAt url: URL) throws -> [Trial] {
		let trialURLs = try scanTrialURLs(fromDirectoryAt: url)
		var trials = [Trial]()
		trials.reserveCapacity(trialURLs.count)
		for url in trialURLs {
			let trial = try TrialScanner.shared.scanTrial(fromFileAtPath: url.path.removingPercentEncoding!)
			trials.append(trial)
		}
		return trials
//		return try trialURLs.map { try TrialScanner.shared.scanTrial(fromFileAtPath: $0.resourceSpecifier.stringByRemovingPercentEncoding!) }
	}
	
	fileprivate func scanTrialURLs(fromDirectoryAt url: URL) throws -> [URL] {
//		let url = NSURL(fileURLWithPath: path, isDirectory: true)
		let fileManager = FileManager()
		let directoryContents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: [URLResourceKey.nameKey], options: [])
		return directoryContents.filter { $0.lastPathComponent.hasPrefix("Trial") }
	}
}
