//
//  ManagedDataManager.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 9/16/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation
import AppKit

let EXPERIMENT_ENTITY_NAME = "Experiment"
let HISTORY_ENTITY_NAME = "History"
let POPULATION_ENTITY_NAME = "Population"
let INDIVIDUAL_ENTITY_NAME = "Individual"

///
public class ManagedDataManager: DataManager {
	
	// MARK: Initializers
	
	///
	public init(context: NSManagedObjectContext, model: NSManagedObjectModel) {
		self.managedObjectContext = context
		self.managedObjectModel = model
	}
	
	// MARK: Instance Properties
	
	///
	public var managedObjectContext: NSManagedObjectContext
	
	///
	public var managedObjectModel: NSManagedObjectModel
	
	public var experiment: ManagedExperiment!
	
	public var currentHistory: ManagedHistory?
	
	public var trialNumber: Int = 0
	
	// MARK: DataManager Protocol
	
	///
	public func beginNewTrial() {
		guard let historyEntity = managedObjectModel.entitiesByName[HISTORY_ENTITY_NAME] else {
			return
		}
		
		let history = ManagedHistory(
			entity: historyEntity,
			insertIntoManagedObjectContext: managedObjectContext)
		
		history.trialNumber = trialNumber
		trialNumber += 1
		
		experiment.histories.addObject(history)
		
		currentHistory = history
	}
	
	/// Creates a new managed experiment and inserts it into the context.
	public func beginRecordingExperiment(experiment: Experiment) {
		guard let experimentEntity = managedObjectModel.entitiesByName[EXPERIMENT_ENTITY_NAME] else {
			return
		}
		
		self.experiment = ManagedExperiment(
			entity: experimentEntity,
			insertIntoManagedObjectContext: managedObjectContext)
		
		self.experiment.adaptFromExperiment(experiment)
		
		self.managedObjectContext.insertObject(self.experiment)
	}
	
	///
	public func recordPopulation(population: Population) {
		
		let populationEntity = managedObjectModel.entitiesByName[POPULATION_ENTITY_NAME]!
		let individualEntity = managedObjectModel.entitiesByName[INDIVIDUAL_ENTITY_NAME]!
		
		let managedPopulation = ManagedPopulation(
			entity: populationEntity,
			insertIntoManagedObjectContext: managedObjectContext)
		
		for individual in population {
			let managedIndividual = ManagedIndividual(
				entity: individualEntity,
				insertIntoManagedObjectContext: managedObjectContext)
			
			managedIndividual.adaptFromIndividual(individual)
			
			managedPopulation.members.addObject(managedIndividual)
		}
		
		currentHistory?.populations.addObject(managedPopulation)
	}
	
}
