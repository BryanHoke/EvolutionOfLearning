//
//  RecordPersisting.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/16/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

protocol RecordPersisting : class {
	
	func persist(record: ExperimentRecord)
	
}

protocol TrialRecordPersisting : class {
	
	func persist(record: TrialRecord)
	
}
