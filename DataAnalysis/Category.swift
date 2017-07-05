//
//  Category.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/12/17.
//  Copyright © 2017 Bryan Hoke. All rights reserved.
//

import Foundation

/// A category of result data.
enum Category : String {
	static var all: Set<Category> {
		return [
			.evolution,
			.networkTest,
			.nonNurturingFitnessTest,
			.nonNurturingGeneralizationTest,
			.nonNurturingLearningTest,
			.nurturingFitnessTest,
			.nurturingGeneralizationTest,
			.nurturingLearningTest
		]
	}
	case evolution = "Evolution"
	case learningTest = "Learning Test"
	case networkTest = "Network Test"
	case nonNurturingFitnessTest = "Non-Nurturing Fitness Test"
	case nonNurturingGeneralizationTest = "Non-Nurturing Generalization Test"
	case nonNurturingLearningTest = "Non-Nurturing Learning Test"
	case nurturingFitnessTest = "Nurturing Fitness Test"
	case nurturingGeneralizationTest = "Nurturing Generalization Test"
	case nurturingLearningTest = "Nurturing Learning Test"
}
