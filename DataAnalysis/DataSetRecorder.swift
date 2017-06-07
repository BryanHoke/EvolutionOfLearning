//
//  DataSetRecorder.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 8/15/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

/// A type that writes data sets to files.
protocol DataSetRecorder : class {
	
	static var shared: Self { get }
	
	func write(dataSet: DataSet, toDirectoryAtPath path: String) throws
}

/// Writes data sets to files, where the data set values are organized into rows.
final class RowwiseDataSetRecorder : DataSetRecorder {
	
	static let shared = RowwiseDataSetRecorder()
	
	func write(dataSet: DataSet, toDirectoryAtPath path: String) throws {
		for (category, values) in dataSet.valuesPerCategory {
			try writeValues(values, forCategory: category, toDirectoryAtPath: path)
		}
	}
	
	private func writeValues(values: [[Double]], forCategory category: String, toDirectoryAtPath path: String) throws {
		let filePath = path + "\(category).csv"
		let fileContent = makeFileContent(values: values)
		try fileContent.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
	}
	
	private func makeFileContent(values values: [[Double]]) -> String {
		guard !values.isEmpty else { return "" }
		
		var content = "# Evolutionary Tasks"
		
		for i in 0..<values[0].count {
			content += ", Generation \(i)"
		}
		
		content += "\n"
		
		for (index, list) in values.enumerate() {
			content += "\(index)"
			
			for value in list {
				content += ", \(value)"
			}
			
			content += "\n"
		}
		
		return content
	}
}

/// Writes data sets to files, where the data set values are organized into columns.
final class ColumnwiseDataSetRecorder : DataSetRecorder {
	
	static let shared = ColumnwiseDataSetRecorder()
	
	func write(dataSet: DataSet, toDirectoryAtPath path: String) throws {
		for (category, values) in dataSet.valuesPerCategory {
			try writeValues(values, forCategory: category, toDirectoryAtPath: path)
		}
	}
	
	private func writeValues(values: [[Double]], forCategory category: String, toDirectoryAtPath path: String) throws {
		let filePath = path + "\(category).csv"
		let fileContent = makeFileContent(values: values)
		try fileContent.writeToFile(filePath, atomically: true, encoding: NSUTF8StringEncoding)
	}
	
	private func makeFileContent(values values: [[Double]]) -> String {
		guard !values.isEmpty else {
			return ""
		}
		
		var headerRowContent = "Generation"
		var contentRows = [String]()
		
		for i in 0..<values[0].count {
			contentRows.append("\(i)")
		}
		
		for (columnIndex, columnValues) in values.enumerate() {
			headerRowContent += ", \(columnIndex + 1) Evolutionary Tasks"
			
			for (rowIndex, value) in columnValues.enumerate() {
				contentRows[rowIndex] += ", \(value)"
			}
		}
		
		return ([headerRowContent] + contentRows).joinWithSeparator("\n")
	}
}
