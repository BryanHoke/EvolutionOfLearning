//
//  ExperimentInterface.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/15/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

protocol ExperimentInterface : class {
	
	var experimentalConditions: [String] { get set }
	
	var selectedConditionIndex: Int? { get set }
	
	var numberOfTrials: Int { get set }
	
	var numberOfGenerations: Int { get set }
	
}
