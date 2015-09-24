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

///
public class ManagedDataManager: DataManager {
	
	// MARK: Initializers
	
	///
	public init(context: NSManagedObjectContext, model: NSManagedObjectModel) {
		
		self.managedObjectContext = context
		
		self.managedObjectModel = model
		
		// Create new managed experiment, insert into context
		if let experimentEntity = managedObjectModel.entitiesByName[EXPERIMENT_ENTITY_NAME] {
			
			self.experiment = ManagedExperiment(entity: experimentEntity, insertIntoManagedObjectContext: managedObjectContext)
			
			self.managedObjectContext.insertObject(self.experiment)
		}
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
	public func recordPopulation(population: Population) {
		
		let managedPopulation = ManagedPopulation()
		
		for individual in population {
			
			let managedIndividual = ManagedIndividual()
			
			managedIndividual.adaptFromIndividual(individual)
			
			managedPopulation.members.append(managedIndividual)
		}
		
		currentHistory?.populations.append(managedPopulation)
	}
	
	///
	public func beginNewTrial() {
		
		let history = ManagedHistory()
		
		history.trialNumber = trialNumber++
		
		experiment.histories.append(history)
		
		currentHistory = history
	}
}