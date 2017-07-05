//
//  DataSet.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 8/11/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

protocol DataSet {
	var valuesPerCategory: [Category: [[Double]]] { get }
}

struct DataSetOverview : DataSet {
	
	var valuesPerCategory: [Category: [[Double]]] = [:]
	
	mutating func accumulate(_ overview: ExperimentOverview) {
		
	}
	
	mutating func accumulate(_ trial: Trial) {
		for (name, values) in trial {
			accumulate(name: name, values: values)
		}
	}
	
	mutating func accumulate(name: String, values: [Double]) {
		guard let category = Category(rawValue: name) else {
			return
		}
		var valueList = valuesPerCategory[category] ?? []
		valueList.append(values)
		valuesPerCategory[category] = valueList
	}
}
