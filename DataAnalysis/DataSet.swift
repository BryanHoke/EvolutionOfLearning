//
//  DataSet.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 8/11/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

struct DataSet {
	
	var valuesPerCategory: [String: [[Double]]] = [:]
	
	mutating func accumulate(_ overview: ExperimentOverview) {
		accumulate(overview.trialAverage)
	}
	
	mutating func accumulate(_ trial: Trial) {
		for (name, values) in trial {
			accumulate(name: name, values: values)
		}
	}
	
	mutating func accumulate(name: String, values: [Double]) {
		var valueList = valuesPerCategory[name] ?? []
		valueList.append(values)
		valuesPerCategory[name] = valueList
	}
}
