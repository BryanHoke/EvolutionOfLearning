//
//  TrialScanner.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 8/10/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

typealias Trial = [String: [Double]]
typealias Record = (name: String, values: [Double])

final class TrialScanner {
	
	static let shared = TrialScanner()
	
	// MARK: Scanning TrialRecords
	
	func scanTrialRecord(fromFileAtPath path: String) throws -> TrialRecord {
		let content = try String(contentsOfFile: path, encoding: .utf8)
		var lines: [String] = content.components(separatedBy: .newlines)
		return parseTrialRecord(from: &lines)
	}
	
	func parseTrialRecord(from lines: inout [String]) -> TrialRecord {
		var trial = TrialRecord()
		while !lines.isEmpty {
			parseTestRecord(from: &lines, into: &trial)
		}
		return trial
	}
	
	private func parseTestRecord(from lines: inout [String], into trial: inout TrialRecord) {
		let name = lines.removeFirst()
		
		// Remove task list and blank line
		stripSection(from: &lines)
		guard !lines.isEmpty else { return }
		
		let values = parsePopulationValues(from: &lines)
		
		guard let category = Category(rawValue: name) else {
			print("Unrecognized category \"\(name)\" encountered.")
			return
		}
		
		let record: TestRecord
		switch category {
		case .evolution:
			record = .sequence(values)
		default:
			record = .value(values[0])
		}
		
		trial.recordsByCategory[category] = record
	}
	
	// MARK: Scanning Dictionaries
	
	func scanTrial(fromFileAtPath path: String) throws -> Trial {
		let content = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
		
		var trial = Trial()
		
		var lines: [String] = content.components(separatedBy: .newlines)
		
		while true {
			parseRecord(from: &lines, into: &trial)
			
			if lines.isEmpty {
				break
			}
		}
		
		return trial
	}
	
	func parseRecords(from content: String) -> Trial {
		var trial = Trial()
		
		var lines: [String] = content.components(separatedBy: .newlines)
		
		while true {
			parseRecord(from: &lines, into: &trial)
			
			if lines.isEmpty {
				break
			}
		}
		
		return trial
	}
	
	private func parseRecord(from lines: inout [String], into trial: inout Trial) {
		let name = lines.removeFirst()
		
		// Remove task list and blank line
		stripSection(from: &lines)
		
		guard !lines.isEmpty else { return }
		
		let values = parsePopulationValues(from: &lines)
		
		trial[name] = values
	}
	
	// MARK: Helpers
	
	func parsePopulationValues(from lines: inout [String]) -> [Double] {
		var values = [Double]()
		
		while !lines.isEmpty {
			// Break if this isn't population data
			if let first = lines.first, !first.hasPrefix("Population") {
				break
			}
			
			// Remove "Population <N>" header
			lines.removeFirst(1)
			
			if let value = parsePopulationValue(from: &lines) {
				values.append(value)
			}
			
			stripSection(from: &lines)
		}
		
		return values
	}
	
	func parsePopulationValue(from lines: inout [String]) -> Double? {
		let line = lines.removeFirst()
		
		let tokens = line.components(separatedBy: " ")
		
		if let token = tokens.first, let value = Double(token) {
			return value
		} else {
			return nil
		}
	}
	
	/// Removes elements from the beginning of `lines` until an empty string is removed or `lines` is empty.
	fileprivate func stripSection(from lines: inout [String]) {
		while !lines.isEmpty {
			let removed = lines.removeFirst()
			if removed.isEmpty {
				break
			}
		}
	}
}
