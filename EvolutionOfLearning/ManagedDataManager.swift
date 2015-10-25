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
		
		if let historyEntity = managedObjectModel.entitiesByName[HISTORY_ENTITY_NAME] {
			
			let history = ManagedHistory(
				entity: historyEntity,
				insertIntoManagedObjectContext: managedObjectContext)
			
			history.trialNumber = trialNumber++
			
			experiment.histories.addObject(history)
			
			currentHistory = history
		}
	}
	
	public func beginRecordingExperiment(experiment: Experiment) {
		// Create new managed experiment, insert into context
		if let experimentEntity = managedObjectModel.entitiesByName[EXPERIMENT_ENTITY_NAME] {
			
			self.experiment = ManagedExperiment(
				entity: experimentEntity,
				insertIntoManagedObjectContext: managedObjectContext)
			
			self.experiment.adaptFromExperiment(experiment)
			
			self.managedObjectContext.insertObject(self.experiment)
		}
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