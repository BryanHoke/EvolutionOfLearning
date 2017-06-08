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
		
//		return parseRecords(from: content as String)
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
	
	func parseRecord(from lines: inout [String], into trial: inout Trial) {
		let name = lines.removeFirst()
		
		stripSection(from: &lines)
		
		guard !lines.isEmpty else { return }
		
		let values = parsePopulationValues(from: &lines)
		
		trial[name] = values
	}
	
	func parsePopulationValues(from lines: inout [String]) -> [Double] {
		var values = [Double]()
		
		while true {
			if let first = lines.first, !first.hasPrefix("Population") {
				break
			}
			
			// Remove "Population <N>" header
			lines.removeFirst(1)
			
			if let value = parsePopulationValue(from: &lines) {
				values.append(value)
			}
			
			stripSection(from: &lines)
			
			if lines.isEmpty {
				break
			}
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
		guard !lines.isEmpty else { return }
		
		while true {
			let removed = lines.removeFirst()
			
			if removed.isEmpty || lines.isEmpty {
				break
			}
		}
	}
}
