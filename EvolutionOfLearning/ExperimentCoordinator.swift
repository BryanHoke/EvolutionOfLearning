//
//  ExperimentCoordinator.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 10/24/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

class ExperimentCoordinator: DocumentEventHandler {
	
	// MARK: Initializers
	
	init() {
		experiment = Experiment()
	}
	
	// MARK: Instance Properties
	
	var dataManager: DataManager?
	
	var experiment: Experiment
	
	// MARK: Document Event Handler
	
	func documentWasCreated(doc: Document)
	{
		dataManager = ManagedDataManager(
			context: doc.managedObjectContext!,
			model: doc.managedObjectModel!)
		
		experiment.dataManager = dataManager
	}
	
	func document(doc: Document,
		environmentPathChanged path: String)
	{
		experiment.environmentPath = path
	}
	
	func document(doc: Document,
		resultsPathChanged path: String)
	{
		
	}
	
	func document(doc: Document,
		numberOfGenerationsChangedToValue value: Int)
	{
		experiment.numberOfGenerations = value
		dataManager?.recordExperimentalNumberOfGenerations(value)
	}
	
	func document(doc: Document,
		numberOfTrialsChangedToValue value: Int)
	{
		experiment.numberOfTrials = value
		dataManager?.recordExperimentalNumberOfTrials(value)
	}
	
	func runButtonClickedForDocument(doc: Document)
	{
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
			self.experiment.run()
		}
	}
}