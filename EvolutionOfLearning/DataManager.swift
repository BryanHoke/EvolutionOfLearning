//
//  DataManager.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/20/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation


///
public protocol DataManager: class {
	
	///
	func recordPopulation(population: Population)
	
	///
	func beginNewTrial()
	
	func recordExperimentalNumberOfGenerations(number: Int)
	
	func recordExperimentalNumberOfTrials(number: Int)
}