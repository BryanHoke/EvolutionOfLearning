//
//  Records.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/13/17.
//  Copyright © 2017 Bryan Hoke. All rights reserved.
//

import Foundation

/// A record of a single test.
enum TestRecord {
	/// A record in the form of a single value.
	case value(Double)
	/// A record in the form of a sequence of values.
	case sequence([Double])
}

/// A record of all the tests in a single trial.
struct TrialRecord {
	/// The records of tests conducted during the trial organized by category.
	var recordsByCategory: [Category: TestRecord] = [:]
}

/// A record of all the trials in a single experiment.
struct ExperimentRecord {
	/// The records of all trials conducted during the experiment.
	var trials: [TrialRecord] = []
}

/// A record of all the experiments in a data set.
struct DataSetRecord {
	/// The records of all experiments in the data set.
	var experiments: [ExperimentRecord] = []
}

extension DataSetRecord : DataSet {
	
	var valuesPerCategory: [Category: [[Double]]] {
		var valuesPerCategory = [Category: [[Double]]]()
		for experiment in experiments {
			// Create a temporary container to store the repetitions for this experiment
			var repsPerCategory = [Category: [Double]]()
			for trial in experiment.trials {
				for (category, record) in trial.recordsByCategory {
					switch record {
					case let .value(value):
						var reps = repsPerCategory[category] ?? []
						reps.append(value)
						repsPerCategory[category] = reps
					default: break
					}
				}
			}
			// Insert the repetitions into the table
			for (category, reps) in repsPerCategory {
				var values = valuesPerCategory[category] ?? []
				values.append(reps)
				valuesPerCategory[category] = values
			}
		}
		return valuesPerCategory
	}
}
