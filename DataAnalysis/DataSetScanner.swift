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
	
	func scanDataSet(fromDirectoryAtPath path: String) throws -> DataSet {
		let overviews = try scanOverviews(fromDirectoryAtPath: path)
		
		var dataSet = DataSet()
		
		for overview in overviews {
			dataSet.accumulate(overview)
		}
		
		return dataSet
	}
	
	private func scanOverviews(fromDirectoryAtPath path: String) throws -> [ExperimentOverview] {
		let urls = try scanExperimentURLs(fromDirectoryAtPath: path)
		var overviews = [ExperimentOverview]()
		overviews.reserveCapacity(urls.count)
		for (index, url) in urls.enumerate() {
			print("Scanning overview \(index)")
			let overview = try ExperimentScanner.shared.scanExperimentOverview(fromDirectoryAt: url)
			overviews.append(overview)
			print("Overview \(index) scanned")
		}
		return overviews
		//		return try urls.map { try ExperimentScanner.shared.scanExperimentOverview(fromDirectoryAt: $0) }
	}
	
	private func scanExperimentURLs(fromDirectoryAtPath path: String) throws -> [NSURL] {
		let url = NSURL(fileURLWithPath: path, isDirectory: true)
		let fileManager = NSFileManager()
		let directoryContents = try fileManager.contentsOfDirectoryAtURL(url, includingPropertiesForKeys: [NSURLNameKey], options: [])
		return directoryContents.filter { $0.lastPathComponent?.hasPrefix("Experiment") ?? false }
	}
}
