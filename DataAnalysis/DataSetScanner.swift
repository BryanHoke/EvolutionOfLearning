//
//  DataSetScanner.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 8/11/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

final class DataSetScanner {
	
	static let shared = DataSetScanner()
	
	// MARK: Scanning DataSetRecords
	
	func scanDataSetRecord(fromDirectoryAtPath path: String) throws -> DataSetRecord {
		let experiments = try scanExperiments(fromDirectoryAtPath: path)
		let dataSet = DataSetRecord(experiments: experiments)
		return dataSet
	}
	
	fileprivate func scanExperiments(fromDirectoryAtPath path: String) throws -> [ExperimentRecord] {
		let urls = try scanExperimentURLs(fromDirectoryAtPath: path)
		var experiments = [ExperimentRecord]()
		experiments.reserveCapacity(urls.count)
		for (index, url) in urls.enumerated() {
			print("Scanning experiment \(index)")
			let experiment = try ExperimentScanner.shared.scanExperimentRecord(fromDirectoryAt: url)
			experiments.append(experiment)
			print("Experiment \(index) scanned")
		}
		return experiments
	}
	
	// MARK: Scanning DataSets
	
	func scanDataSet(fromDirectoryAtPath path: String, shouldWriteAverages: Bool = false) throws -> DataSet {
		let overviews = try scanOverviews(fromDirectoryAtPath: path)
		
		var dataSet = DataSetOverview()
		
		for overview in overviews {
			if shouldWriteAverages {
				dataSet.accumulate(overview.trialAverage)
			}
			else {
				dataSet.accumulate(overview)
			}
		}
		
		return dataSet
	}
	
	fileprivate func scanOverviews(fromDirectoryAtPath path: String) throws -> [ExperimentOverview] {
		let urls = try scanExperimentURLs(fromDirectoryAtPath: path)
		var overviews = [ExperimentOverview]()
		overviews.reserveCapacity(urls.count)
		for (index, url) in urls.enumerated() {
			print("Scanning overview \(index)")
			let overview = try ExperimentScanner.shared.scanExperimentOverview(fromDirectoryAt: url)
			overviews.append(overview)
			print("Overview \(index) scanned")
		}
		return overviews
	}
	
	// MARK: Helpers
	
	/// Returns the URLs of all the experiment directories contained in the directory at the given path.
	fileprivate func scanExperimentURLs(fromDirectoryAtPath path: String) throws -> [URL] {
		let url = URL(fileURLWithPath: path, isDirectory: true)
		let fileManager = FileManager()
		let directoryContents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: [URLResourceKey.nameKey], options: [])
		return directoryContents.filter { $0.lastPathComponent.hasPrefix("Experiment") }
	}
}
