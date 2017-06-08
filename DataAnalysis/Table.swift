//
//  Table.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/8/17.
//  Copyright © 2017 Bryan Hoke. All rights reserved.
//

import Foundation

/// A structure containing values organized into rows and columns.
struct Table<Value> {
	
	/// The backing structure.
	private var values: [[Value]] = []
	
	init(values: [[Value]]) {
		self.values = values
	}
	
	/// The Table's rows.
	var rows: [[Value]] {
		return values
	}
	
	/// Appends a row to the end of the Table.
	mutating func appendRow(_ row: [Value]) {
		values.append(row)
	}
	
	/// Accesses the Value at the specified row and column.
	subscript(row: Int, column: Int) -> Value {
		get {
			return values[row][column]
		}
		set {
			values[row][column] = newValue
		}
	}
}
