//
//  PopulationOperator.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/23/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

private var __rouletteWheelSelection_once: () = { () -> Void in
    srand48(Int(arc4random()))
}()

public struct PopulationOperator<Member : Individual> : PopulationOperating {
	
	public typealias PopulationType = Population<Member>
	
	public typealias ChromosomeType = Member.ChromosomeType
	
	public typealias CrossoverOperator = (ChromosomeType, ChromosomeType) -> (ChromosomeType, ChromosomeType)
	
	public func elitistSelection(from population: PopulationType, taking count: Int) -> PopulationType {
		return PopulationType(members: Array(population.members.sorted(by: <)[0..<count]))
	}
	
	public func rouletteWheelSelection(from population: PopulationType, taking count: Int) -> PopulationType {
		let newMembers = (0..<count).map { _ in self.rouletteWheelSelection(from: population) }
		return PopulationType(members: newMembers)
	}
	
	public func rouletteWheelSelection(from population: PopulationType) -> Member {
		_ = __rouletteWheelSelection_once
		
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
			return members.remove(at: index)
		}
		return PopulationType(members: newMembers)
	}
	
	public func mutate(_ population: inout PopulationType, rate: Double) {
		population.visitMembers { (member: inout Member) in
			member.chromosome.mutate(withRate: rate)
		}
	}
	
	public func clone(_ population: PopulationType) -> PopulationType {
		let newMembers = population.map { $0.clone() }
		return PopulationType(members: newMembers)
	}
	
	public func crossover(_ population: PopulationType, using crossoverOperator: CrossoverOperator) -> PopulationType {
		var newMembers: [Member] = []
		newMembers.reserveCapacity(population.count)
		
		for pair in population.pairs {
			let offspring = Member.crossover(pair, using: crossoverOperator)
			newMembers += [offspring.0, offspring.1]
		}
		
		return PopulationType(members: newMembers)
	}
	
}
