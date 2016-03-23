//
//  PopulationOperator.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/23/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct PopulationOperator: PopulationOperating {
	
	public func elitistSelection(from population: Population, taking count: Int) -> Population {
		return Population(members: Array(population.members.sort(<)[0..<count]))
	}
	
	public func rouletteWheelSelection(from population: Population, taking count: Int) -> Population {
		let newMembers = (0..<count).map { _ in self.rouletteWheelSelection(from: population) }
		return Population(members: newMembers)
	}
	
	public func rouletteWheelSelection(from population: Population) -> Individual {
		var onceToken: dispatch_once_t = 0
		dispatch_once(&onceToken) { () -> Void in
			srand48(Int(arc4random()))
		}
		
		let fitnessRatioThreshold = drand48()
		
		let totalFitness = population.totalFitness
		var selectionIndex = 0
		var selectionIndividual: Individual
		var fitnessRatioSum = 0.0
		
		repeat {
			selectionIndividual = population[selectionIndex]
			selectionIndex += 1
			fitnessRatioSum += selectionIndividual.fitness / totalFitness
		} while fitnessRatioSum < fitnessRatioThreshold
		
		return selectionIndividual
	}
	
	public func uniformSelection(from population: Population, taking count: Int) -> Population {
		var members = population.members
		let newMembers: [Individual] = (0..<count).map { i in
			let index = Int(arc4random_uniform(UInt32(count - i)))
			return members.removeAtIndex(index)
		}
		return Population(members: newMembers)
	}
	
	public func mutate(inout population: Population, rate: Double) {
		population.visitMembers { (inout member: Individual) in
			member.chromosome.mutateInPlaceWithRate(rate)
		}
	}
	
	public func clone(population: Population) -> Population {
		let newMembers = population.map { $0.clone() }
		return Population(members: newMembers)
	}
	
	public func crossover(population: Population, using crossoverOperator: CrossoverOperator) -> Population {
		var newMembers: [Individual] = []
		newMembers.reserveCapacity(population.count)
		
		for pair in population.pairs {
			let offspring = Individual.crossover(pair, using: crossoverOperator)
			newMembers += [offspring.0, offspring.1]
		}
		
		return Population(members: newMembers)
	}
	
}