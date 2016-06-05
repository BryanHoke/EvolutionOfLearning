//
//  PopulationOperating.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/23/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public protocol PopulationOperating {
	
	associatedtype Member : Individual
	
	func elitistSelection(from population: Population<Member>, taking count: Int) -> Population<Member>
	
	func rouletteWheelSelection(from population: Population<Member>, taking count: Int) -> Population<Member>
	
	func uniformSelection(from population: Population<Member>, taking count: Int) -> Population<Member>
	
	func mutate(inout population: Population<Member>, rate: Double)
	
	func clone(population: Population<Member>) -> Population<Member>
	
	func crossover(population: Population<Member>, using crossoverOperator: (Member.ChromosomeType, Member.ChromosomeType) -> (Member.ChromosomeType, Member.ChromosomeType)) -> Population<Member>
	
}
