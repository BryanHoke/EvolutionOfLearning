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
		
		let fileContent = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
		
		let lines: [String] = fileContent.componentsSeparatedByCharactersInSet(.newlineCharacterSet())
		
		for line in lines {
			let tokens: [String] = line.componentsSeparatedByString(",")
			table.append(tokens)
		}
		
		return table
	}
	
	func scanValues(fromFilesAtPaths paths: [String], rowIndices: [Int], columnIndices: [Int]) throws -> [[[String]]] {
		var values: [[[String]]] = .init(count: columnIndices.count, repeatedValue: .init(count: rowIndices.count, repeatedValue: []))
		
		for path in paths {
			let table = try scanTable(fromFileAtPath: path)
			
			for (i, row) in rowIndices.enumerate() {
				for (j, col) in columnIndices.enumerate() {
					values[i][j].append(table[row][col])
				}
			}
		}
		
		return values
	}
	
}
