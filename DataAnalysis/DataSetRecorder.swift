//
//  DataSetRecorder.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 8/15/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

/// A type that writes data sets to files.
protocol DataSetRecording : class {
	/// Writes the contents of a `DataSet` into a directory at the given path.
	func write(_ dataSet: DataSet, toDirectoryAtPath path: String) throws
}

/// A type that writes the contents of `DataSet` instances into files.
final class DataSetRecorder : DataSetRecording {
	
	/// A `DataSetRecorder` that formats its output into rows.
	static let rowwise = DataSetRecorder(formatter: RowwiseOutputFormatter())
	
	/// A `DataSetRecorder` that formats its output into columns.
	static let columnwise = DataSetRecorder(formatter: ColumnwiseOutputFormatter())
	
	/// Formats the `DataSet` values for output to files.
	let formatter: OutputFormatting
	
	init(formatter: OutputFormatting) {
		self.formatter = formatter
	}
	
	func write(_ dataSet: DataSet, toDirectoryAtPath path: String) throws {
		for (category, values) in dataSet.valuesPerCategory {
			try writeValues(values, forCategory: category, toDirectoryAtPath: path)
		}
	}
	
	fileprivate func writeValues(_ values: [[Double]], forCategory category: String, toDirectoryAtPath path: String) throws {
		let filePath = path + "\(category).csv"
		let fileContent = formatter.format(values)
		try fileContent.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
	}
}
