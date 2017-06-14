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
	
	// MARK: Scanning ExperimentRecords
	
	func scanExperimentRecord(fromDirectoryAtPath path: String) throws -> ExperimentRecord {
		let url = URL(fileURLWithPath: path, isDirectory: true)
		return try scanExperimentRecord(fromDirectoryAt: url)
	}
	
	func scanExperimentRecord(fromDirectoryAt url: URL) throws -> ExperimentRecord {
		let trials = try scanTrialRecords(fromDirectoryAt: url)
		
		var experiment = ExperimentRecord()
		
		for trial in trials {
			experiment.trials.append(trial)
		}
		
		return experiment
	}
	
	fileprivate func scanTrialRecords(fromDirectoryAt url: URL) throws -> [TrialRecord] {
		let trialURLs = try scanTrialURLs(fromDirectoryAt: url)
		var trials = [TrialRecord]()
		trials.reserveCapacity(trialURLs.count)
		for url in trialURLs {
			let trial = try TrialScanner.shared.scanTrialRecord(fromFileAtPath: url.path.removingPercentEncoding!)
			trials.append(trial)
		}
		return trials
	}
	
	// MARK: Scanning ExperimentOverviews
	
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
	}
	
	// MARK: Helpers
	
	/// Returns the URLs of all the trial files contained in the directory at the given URL.
	fileprivate func scanTrialURLs(fromDirectoryAt url: URL) throws -> [URL] {
		let fileManager = FileManager()
		let directoryContents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: [URLResourceKey.nameKey], options: [])
		return directoryContents.filter { $0.lastPathComponent.hasPrefix("Trial") }
	}
}
