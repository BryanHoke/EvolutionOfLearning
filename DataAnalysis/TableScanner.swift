//
//  TableScanner.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/15/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

typealias StringTable = Table<String>

final class TableScanner {
	
	static let sharedScanner = TableScanner()
	
	func scanTable(fromFileAtPath path: String) throws -> [[String]] {
		var table = [[String]]()
		
		let fileContent = try NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue)
		
		let lines: [String] = fileContent.components(separatedBy: .newlines)
		
		for line in lines {
			let tokens: [String] = line.components(separatedBy: ",")
			table.append(tokens)
		}
		
		return table
	}
	
	func scanValues(fromFilesAtPaths paths: [String], rowIndices: [Int], columnIndices: [Int]) throws -> [[[String]]] {
		var values: [[[String]]] = .init(repeating: .init(repeating: [], count: rowIndices.count), count: columnIndices.count)
		
		for path in paths {
			let table = try scanTable(fromFileAtPath: path)
			
			for (i, row) in rowIndices.enumerated() {
				for (j, col) in columnIndices.enumerated() {
					values[i][j].append(table[row][col])
				}
			}
		}
		
		return values
	}
	
}
