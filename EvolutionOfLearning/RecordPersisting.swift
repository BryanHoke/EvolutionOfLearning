//
//  RecordPersisting.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/16/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

protocol RecordPersisting : class {
	
	associatedtype Record : ExperimentRecord
	
	func persist(record: Record)
	
}

protocol TrialRecordPersisting : class {
	
	associatedtype Record : TrialRecord
	
	func persist(record: Record)
	
}
