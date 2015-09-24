//
//  ManagedObjects.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 9/15/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation
import AppKit


public class ManagedIndividual: NSManagedObject {
	
	@NSManaged public var chromosome: String
	
	@NSManaged var fitness: Double
	
	@NSManaged var id: String
	
	@NSManaged var parentID1: String?
	
	@NSManaged var parentID2: String?
	
	@NSManaged var population: ManagedPopulation
	
	/// Adapts the property values of a `GeneticIndividual` onto this model's properties.
	public func adaptFromIndividual(individual: GeneticIndividual) {
		
		chromosome = individual.chromosome.stringValue
		
		fitness = individual.fitness
		
		id = individual.id.UUIDString
		
		parentID1 = individual.parentID1?.UUIDString
		
		parentID2 = individual.parentID2?.UUIDString
	}
}


public class ManagedPopulation: NSManagedObject {
	
	@NSManaged var fitnessAverage: Double
	
	@NSManaged var fitnessTotal: Double
	
	@NSManaged var generation: Int
	
	@NSManaged var history: ManagedHistory
	
	@NSManaged var members: [ManagedIndividual]
}


public class ManagedHistory: NSManagedObject {
	
	@NSManaged var trialNumber: Int
	
	@NSManaged var experiment: ManagedExperiment
	
	@NSManaged var populations: [ManagedPopulation]
}


public class ManagedExperiment: NSManagedObject {
	
	@NSManaged var numberOfGenerations: Int
	
	@NSManaged var numberOfTrials: Int
	
	@NSManaged var histories: [ManagedHistory]
}