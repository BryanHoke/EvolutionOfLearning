//
//  OutputFormatting.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/13/17.
//  Copyright © 2017 Bryan Hoke. All rights reserved.
//

import Foundation

/// A type that determines how two-dimensional data should be formatted for output.
protocol OutputFormatting {
	/// Formats the specified values for output.
	func format(_ values: [[Double]]) -> String
}

/// A type that formats two-dimensional data into rows.
struct RowwiseOutputFormatter : OutputFormatting {
	func format(_ values: [[Double]]) -> String {
		guard !values.isEmpty else { return "" }
		
		var content = "# Evolutionary Tasks"
		for i in 0..<values[0].count {
			content += ", Generation \(i)"
		}
		content += "\n"
		
		for (index, list) in values.enumerated() {
			content += "\(index)"
			for value in list {
				content += ", \(value)"
			}
			content += "\n"
		}
		
		return content
	}
}

/// A type that formats two-dimensional data into columns.
struct ColumnwiseOutputFormatter : OutputFormatting {
	func format(_ values: [[Double]]) -> String {
		guard !values.isEmpty else {
			return ""
		}
		
		var headerRowContent = "Generation"
		var contentRows = [String]()
		for i in 0..<values[0].count {
			contentRows.append("\(i)")
		}
		
		for (columnIndex, columnValues) in values.enumerated() {
			headerRowContent += ", \(columnIndex + 1) Evolutionary Tasks"
			for (rowIndex, value) in columnValues.enumerated() {
				contentRows[rowIndex] += ", \(value)"
			}
		}
		
		return ([headerRowContent] + contentRows).joined(separator: "\n")
	}
}
