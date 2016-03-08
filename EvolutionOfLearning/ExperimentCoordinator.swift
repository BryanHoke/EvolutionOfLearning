//
//  ExperimentCoordinator.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 10/24/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

class ExperimentCoordinator: DocumentEventHandler, ExperimentOutput {
	
	// MARK: - Initializers
	
	init() {
		experiment = Experiment()
		experiment.output = self
	}
	
	// MARK: - Instance Properties
	
	var dataManager: DataManager?
	
	weak var document: Document?
	
	var experiment: Experiment
	
	// MARK: - Instance Methods
	
	// MARK: Document Event Handler
	
	func documentWasCreated(doc: Document) {
		document = doc
		
		dataManager = ManagedDataManager(
			context: doc.managedObjectContext!,
			model: doc.managedObjectModel!)
		
		experiment.environmentPath = doc.environmentPath
	}
	
	func document(doc: Document, environmentPathChanged path: String) {
		experiment.environmentPath = path
	}
	
	func document(doc: Document, resultsPathChanged path: String) {
		
	}
	
	func document(doc: Document, numberOfGenerationsChangedToValue value: Int) {
		experiment.numberOfGenerations = value
	}
	
	func document(doc: Document, numberOfTrialsChangedToValue value: Int) {
		experiment.numberOfTrials = value
	}
	
	func runButtonClickedForDocument(doc: Document) {
		dataManager?.beginRecordingExperiment(experiment)
		
		// Run the experiment off the main thread
		dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
//			self.experiment.run()
		}
	}
	
	// MARK: Experiment Output
	
	func experimentDidBeginNewTrial(experiment: Experiment) {
		dispatch_async(dispatch_get_main_queue()) {
			self.dataManager?.beginNewTrial()
		}
	}
	
	func experiment(experiment: Experiment, didEvaluatePopulation pop: Population) {
		dispatch_async(dispatch_get_main_queue()) {
			self.dataManager?.recordPopulation(pop)
		}
	}
	
	func experimentDidComplete(experiment: Experiment) {
		dispatch_async(dispatch_get_main_queue()) {
			self.document?.writeExperiment()
		}
	}
	
}
