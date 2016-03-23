//
//  PopulationOperating.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/23/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public protocol PopulationOperating {
	
	func elitistSelection(from population: Population, taking count: Int) -> Population
	
	func rouletteWheelSelection(from population: Population, taking count: Int) -> Population
	
	func uniformSelection(from population: Population, taking count: Int) -> Population
	
	func mutate(inout population: Population, rate: Double)
	
	func clone(population: Population) -> Population
	
	func crossover(population: Population, using crossoverOperator: CrossoverOperator) -> Population
	
}
