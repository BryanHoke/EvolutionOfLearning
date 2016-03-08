//
//  Environment.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/19/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation
import Darwin

public typealias TaskFitnessFunc = (Chromosome, Task) -> Double

public protocol EvolutionaryEnvironment {
	
	func makePopulation(size size: Int) -> Population
	
	func seeding() -> () -> Chromosome
	
	func fitness(of chromosome: Chromosome) -> Double
	
	func reproduce(population: Population) -> Population
	
}

public class Environment {
	
}