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
		let url = NSURL(fileURLWithPath: path, isDirectory: true)
		return try scanExperimentOverview(fromDirectoryAt: url)
	}
	
	func scanExperimentOverview(fromDirectoryAt url: NSURL) throws -> ExperimentOverview {
		let trials = try scanTrials(fromDirectoryAt: url)
		
		var overview = ExperimentOverview()
		
		for trial in trials {
			overview.accumulate(trial)
		}
		
		return overview
	}
	
	private func scanTrials(fromDirectoryAt url: NSURL) throws -> [Trial] {
		let trialURLs = try scanTrialURLs(fromDirectoryAt: url)
		var trials = [Trial]()
		trials.reserveCapacity(trialURLs.count)
		for url in trialURLs {
			let trial = try TrialScanner.shared.scanTrial(fromFileAtPath: url.resourceSpecifier!.stringByRemovingPercentEncoding!)
			trials.append(trial)
		}
		return trials
//		return try trialURLs.map { try TrialScanner.shared.scanTrial(fromFileAtPath: $0.resourceSpecifier.stringByRemovingPercentEncoding!) }
	}
	
	private func scanTrialURLs(fromDirectoryAt url: NSURL) throws -> [NSURL] {
//		let url = NSURL(fileURLWithPath: path, isDirectory: true)
		let fileManager = NSFileManager()
		let directoryContents = try fileManager.contentsOfDirectoryAtURL(url, includingPropertiesForKeys: [NSURLNameKey], options: [])
		return directoryContents.filter { $0.lastPathComponent?.hasPrefix("Trial") ?? false }
	}
}
