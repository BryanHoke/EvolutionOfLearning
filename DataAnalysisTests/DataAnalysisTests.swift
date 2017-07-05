//
//  DataAnalysisTests.swift
//  DataAnalysisTests
//
//  Created by Bryan Hoke on 6/15/17.
//  Copyright © 2017 Bryan Hoke. All rights reserved.
//

import XCTest
@testable import DataAnalysis

class DataAnalysisTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
		let values = [
			0.111,
			0.121,
			0.112,
			0.122,
			0.211,
			0.221,
			0.212,
			0.222
		]
		
		let experiment1: ExperimentRecord
		do {
			let trial1 = TrialRecord(recordsByCategory: [
				.nonNurturingFitnessTest: .value(values[0]),
				.nurturingFitnessTest: .value(values[1])
				])
			let trial2 = TrialRecord(recordsByCategory: [
				.nonNurturingFitnessTest: .value(values[2]),
				.nurturingFitnessTest: .value(values[3])
				])
			experiment1 = ExperimentRecord(trials: [
				trial1,
				trial2])
		}
		let experiment2: ExperimentRecord
		do {
			let trial1 = TrialRecord(recordsByCategory: [
				.nonNurturingFitnessTest: .value(values[4]),
				.nurturingFitnessTest: .value(values[5])
				])
			let trial2 = TrialRecord(recordsByCategory: [
				.nonNurturingFitnessTest: .value(values[6]),
				.nurturingFitnessTest: .value(values[7])
				])
			experiment2 = ExperimentRecord(trials: [
				trial1,
				trial2])
		}
		let dataSet = DataSetRecord(experiments: [
			experiment1,
			experiment2])
		let valuesPerCategory = dataSet.valuesPerCategory
		print(valuesPerCategory)
		let formatter = ColumnwiseOutputFormatter()
		for (category, values) in valuesPerCategory {
			print("\(category): \(formatter.format(values))")
		}
    }
}
