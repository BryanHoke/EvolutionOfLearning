//
//  ChalmersTrial.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/11/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public typealias FitnessAgentFactory = (tasks: [Task]) -> FitnessAgent

public struct ChalmersTrial {
	
	public let dataManager: DataManager
	
	public let evolution: Evolution
	
	public let learningTest: LearningTest
	
}