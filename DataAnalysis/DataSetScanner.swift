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
		//		return try urls.map { try ExperimentScanner.shared.scanExperimentOverview(fromDirectoryAt: $0) }
	}
	
	fileprivate func scanExperimentURLs(fromDirectoryAtPath path: String) throws -> [URL] {
		let url = URL(fileURLWithPath: path, isDirectory: true)
		let fileManager = FileManager()
		let directoryContents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: [URLResourceKey.nameKey], options: [])
		return directoryContents.filter { $0.lastPathComponent.hasPrefix("Experiment") }
	}
}
