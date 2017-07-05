//
//  CSVRecordPersister.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/16/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

class CSVRecordPersister<Record : ExperimentRecord> : RecordPersisting {
	
	var resultsPath: String {
		return "/Users/bryanhoke/Projects/BDHSoftware/EvolutionOfLearning/Results/"
	}
	
	func persist(_ record: Record) {
		
	}
	
}
