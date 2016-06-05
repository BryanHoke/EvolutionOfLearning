//
//  PopulationOperator.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/23/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct PopulationOperator<Member : Individual> : PopulationOperating {
	
	public typealias PopulationType = Population<Member>
	
	public typealias ChromosomeType = Member.ChromosomeType
	
	public typealias CrossoverOperator = (ChromosomeType, ChromosomeType) -> (ChromosomeType, ChromosomeType)
	
	public func elitistSelection(from population: PopulationType, taking count: Int) -> PopulationType {
		return PopulationType(members: Array(population.members.sort(<)[0..<count]))
	}
	
	public func rouletteWheelSelection(from population: PopulationType, taking count: Int) -> PopulationType {
		let newMembers = (0..<count).map { _ in self.rouletteWheelSelection(from: population) }
		return PopulationType(members: newMembers)
	}
	
	public func rouletteWheelSelection(from population: PopulationType) -> Member {
		var onceToken: dispatch_once_t = 0
		dispatch_once(&onceToken) { () -> Void in
			srand48(Int(arc4random()))
		}
		
		let fitnessRatioThreshold = drand48()
		
		let totalFitness = population.totalFitness
		var selectionIndex = 0
		var selectionMember: Member
		var fitnessRatioSum = 0.0
		
		repeat {
			selectionMember = population[selectionIndex]
			selectionIndex += 1
			fitnessRatioSum += selectionMember.fitness / totalFitness
		} while fitnessRatioSum < fitnessRatioThreshold
		
		return selectionMember
	}
	
	public func uniformSelection(from population: PopulationType, taking count: Int) -> PopulationType {
		var members = population.members
		let newMembers: [Member] = (0..<count).map { i in
			let index = Int(arc4random_uniform(UInt32(count - i)))
			return members.removeAtIndex(index)
		}
		return PopulationType(members: newMembers)
	}
	
	public func mutate(inout population: PopulationType, rate: Double) {
		population.visitMembers { (inout member: Member) in
			member.chromosome.mutate(withRate: rate)
		}
	}
	
	public func clone(population: PopulationType) -> PopulationType {
		let newMembers = population.map { $0.clone() }
		return PopulationType(members: newMembers)
	}
	
	public func crossover(population: PopulationType, using crossoverOperator: CrossoverOperator) -> PopulationType {
		var newMembers: [Member] = []
		newMembers.reserveCapacity(population.count)
		
		for pair in population.pairs {
			let offspring = Member.crossover(pair, using: crossoverOperator)
			newMembers += [offspring.0, offspring.1]
		}
		
		return PopulationType(members: newMembers)
	}
	
}