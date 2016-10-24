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
		let content = try NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
		
		var trial = Trial()
		
		var lines: [String] = content.componentsSeparatedByCharactersInSet(.newlineCharacterSet())
		
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
		
		var lines: [String] = content.componentsSeparatedByCharactersInSet(.newlineCharacterSet())
		
		while true {
			parseRecord(from: &lines, into: &trial)
			
			if lines.isEmpty {
				break
			}
		}
		
		return trial
	}
	
	func parseRecord(inout from lines: [String], inout into trial: Trial) {
		let name = lines.removeFirst()
		
		stripSection(from: &lines)
		
		guard !lines.isEmpty else { return }
		
		let values = parsePopulationValues(from: &lines)
		
		trial[name] = values
	}
	
	func parsePopulationValues(inout from lines: [String]) -> [Double] {
		var values = [Double]()
		
		while true {
			if let first = lines.first where !first.hasPrefix("Population") {
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
	
	func parsePopulationValue(inout from lines: [String]) -> Double? {
		let line = lines.removeFirst()
		
		let tokens = line.componentsSeparatedByString(" ")
		
		if let token = tokens.first, let value = Double(token) {
			return value
		} else {
			return nil
		}
	}
	
	/// Removes elements from the beginning of `lines` until an empty string is removed or `lines` is empty.
	private func stripSection(inout from lines: [String]) {
		guard !lines.isEmpty else { return }
		
		while true {
			let removed = lines.removeFirst()
			
			if removed.isEmpty || lines.isEmpty {
				break
			}
		}
	}
}
