//
//  TextRecordPersister.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/17/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

struct TextRecordPersister<Record : ExperimentRecord> {
	
	func persist(_ record: Record, inDirectory directoryPath: String) {
		let configWriter = ConfigFileWriter()
		configWriter.write(record.config, inDirectory: directoryPath)
		
		let trialWriter = TrialRecordFileWriter<Record.Record>()
		for (index, trial) in record.trials.enumerated() {
			trialWriter.persist(trial, withIndex: index, inDirectory: directoryPath)
		}
	}
	
}
