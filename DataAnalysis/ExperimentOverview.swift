//
//  ExperimentOverview.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 8/10/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

struct ExperimentOverview {
	
	var valuesPerTrial: [String: [[Double]]] = [:]
	
	var trialAverage: Trial {
		var average = Trial()
		
		for (key, valueLists) in valuesPerTrial {
			average[key] = means(ofValues: valueLists)
		}
		
		return average
	}
	
	func means(ofValues values: [[Double]]) -> [Double] {
		var means = [Double]()
		let count = values.first?.count ?? 0
		means.reserveCapacity(count)
		let divisor = Double(values.count)
		
		for i in 0..<count {
			let sum = values.reduce(0) { $0 + $1[i] }
			let mean = sum / divisor
			means.append(mean)
		}
		
		return means
	}
	
	mutating func accumulate(trial: Trial) {
		for (name, values) in trial {
			accumulate((name: name, values: values))
		}
	}
	
	mutating func accumulate(record: Record) {
		let key = record.name
		
		var values = valuesPerTrial[key] ?? []
		values.append(record.values)
		valuesPerTrial[key] = values
	}
	
}
