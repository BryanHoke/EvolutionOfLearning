//
//  Population.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/28/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation
import Darwin

public struct Population: CollectionType, ArrayLiteralConvertible {
	
	///
	public static func uniformSelection(count: Int)(population: Population) -> Population {
			
		let selectionIndices = uniformSelectionIndices(count)(population: population)
		
		return population.populationWithSelectionIndices(selectionIndices)
	}
	
	///
	public static func uniformSelectionIndices(count: Int)(population: Population) -> Set<Int> {
		
		var selectedIndices = Set<Int>()
		var pool = (0..<population.count).map { $0 }
		let selectionCount = min(count, pool.count)
		
		for i in 0..<selectionCount {
			let index = Int(arc4random_uniform(UInt32(selectionCount - i)))
			selectedIndices.insert(pool.removeAtIndex(index))
		}
		
		return selectedIndices
	}
	
	public typealias Element = Individual
	
	public typealias Index = Int
	
	public typealias Generator = IndexingGenerator<[Individual]>
	
	public init() {
		members = [Individual]()
	}
	
	public init(arrayLiteral elements: Individual...) {
		members = elements
	}
	
	public var members = [Individual]()
	
	var totalFitness: Double {
		return members.map { $0.fitness }.reduce(0, combine: +)
	}
	
	/// Selects the top *n* members of the population ranked by fitness and returns them in a new population.
	/// - parameter elitistCount: The number of most-fit individuals to selected.
	/// - returns: A new `Population` containing the top *n* fitness-ranked members of `self` (where *n* is equal to `elitistCount`).
	public func elitismSelectionWithCount(elitistCount: Int) -> Population {
		var elitistPopulation = self
		for index in 0..<elitistCount {
			elitistPopulation.append(self[index])
		}
		return elitistPopulation
	}
	
	/// Evaluates the fitness of each of the `members` with *fitnessFunc*.
	public func evaluateWithFitnessFunc(fitnessFunc: FitnessFunc) {
		// Create dispatch queue and group
		let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
		let group = dispatch_group_create()
		
		// Concurrently evaluate fitness of all individuals
		for individual in self {
			dispatch_group_async(group, queue, { () -> Void in
				individual.fitness = fitnessFunc(individual.chromosome)
			})
		}
		
		// Wait until all individuals have been evaluated
		dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
	}
	
	///
	public func pairs() -> [(Individual, Individual)] {
		var pairings = [(Individual, Individual)]()
		for index in 0.stride(through: count, by: 2) {
			pairings.append((self[index], self[index + 1]))
		}
		return pairings
	}
	
	///
	public func reproduceWithCrossover(crossoverOperator: CrossoverOperator) -> Population {
		
		var offspringPopulation = Population()
		
		for pair in pairs() {
			
			let offspringPair = pair.0.reproduceWithCrossover(crossoverOperator, pairIndividual: pair.1)
			
			offspringPopulation += [offspringPair.0, offspringPair.1]
		}
		
		return offspringPopulation
	}
	
	///
	public func reproduceWithMutation(mutationOperator: MutationOperator) -> Population {
		var offspringPopulation = Population()
		for individual in self {
			let offspring = individual.reproduceWithMutation(mutationOperator)
			offspringPopulation.append(offspring)
		}
		return offspringPopulation
	}
	
	///
	public func reproduceWithRecombination(recombinationOperator: RecombinationOperator) -> Population
	{
		var offspringPopulation = Population()
		for pair in pairs() {
			let offspring = pair.0.reproduceWithRecombination(recombinationOperator, pairIndividual: pair.1)
			offspringPopulation.append(offspring)
		}
		return offspringPopulation
	}
	
	///
	public func rouletteWheelSelection(newPopulationSize newPopulationSize: Int? = nil, excludedIndices: Set<Int> = Set<Int>()) -> Population {
		var includedPopulation = self
		for excludedIndex in excludedIndices {
			includedPopulation.members.removeAtIndex(excludedIndex)
		}
		
		var selectedPopulation = Population()
		let newPopulationSize = newPopulationSize ?? members.count
		for _ in 0..<newPopulationSize {
			let selectedIndividual = includedPopulation.rouletteWheelSelect()
			selectedPopulation.append(selectedIndividual)
		}
		
		return selectedPopulation
	}
	
	/// Selects and returns an individual in this `Population` using the "roulette wheel" method.
	public func rouletteWheelSelect() -> Individual {
		let totalFitness = self.totalFitness
		var onceToken: dispatch_once_t = 0
		dispatch_once(&onceToken) { () -> Void in
			srand48(Int(arc4random()))
		}
		let random = drand48()
		var selectionIndex = 0
		var selectionIndividual: Individual
		var fitnessRatioSum: Double = 0
		
		repeat {
			selectionIndividual = self[selectionIndex++]
			fitnessRatioSum += selectionIndividual.fitness / totalFitness
		} while fitnessRatioSum < random
		
		return selectionIndividual
	}
	
	///
	public func populationWithSelectionIndices(indices: Set<Int>) -> Population {
		
		var selectedPopulation = Population()
		
		for index in indices {
			selectedPopulation.append(self[index])
		}
		
		return selectedPopulation
	}
	
	///
	public func populationWithExcludedIndices(indices: Set<Int>) -> Population {
		
		var allIndices = Set<Int>()
		for i in 0..<count {
			allIndices.insert(i)
		}
		
		let selectionIndices = allIndices.subtract(indices)
		
		return self.populationWithSelectionIndices(selectionIndices)
	}
	
	/// Selects a subset of the population, where all members have an equal chance of being selected.
	/// - parameter count: The number of members to select.
	public func populationWithUniformSelection(count: Int) -> Population {
		
		var newPopulation = Population()
		var pool = self
		let newPopulationSize = min(count, pool.count)
		
		for i in 0..<newPopulationSize {
			let index = Int(arc4random_uniform(UInt32(newPopulationSize - i)))
			newPopulation.append(pool.members.removeAtIndex(index))
		}
		
		return newPopulation
	}
	
	///
	public func selectionBranch(branchSelector: Population -> Set<Int>, branchHandler: (selected: Population, unselected: Population) -> ()) {
		
		let selectionIndices = branchSelector(self)
		
		let selectedPopulation = self.populationWithSelectionIndices(selectionIndices)
		let unselectedPopulation = self.populationWithExcludedIndices(selectionIndices)
		
		branchHandler(selected: selectedPopulation, unselected: unselectedPopulation)
	}
	
	public var count: Int {
		return members.count
	}
	
	public var endIndex: Int {
		return members.endIndex
	}
	
	public var isEmpty: Bool {
		return members.isEmpty
	}
	
	public var startIndex: Int {
		return members.startIndex
	}
	
	public mutating func append(newElement: Individual) {
		members.append(newElement)
	}
	
	public mutating func extend(newElements: [Individual]) {
		members.appendContentsOf(newElements)
	}
	
	public func generate() -> IndexingGenerator<[Individual]> {
		return members.generate()
	}
	
	public mutating func reserveCapacity(n: Int) {
		members.reserveCapacity(n)
	}
	
	public subscript(index: Int) -> Individual {
		get {
			return members[index]
		}
		set {
			members[index] = newValue
		}
	}
	
}

public func +(lhs: Population, rhs: Population) -> Population {
	return lhs + rhs.members
}

public func +(lhs: Population, rhs: [Individual]) -> Population {
	var newPopulation = lhs
	newPopulation.members += rhs
	return newPopulation
}

public func +=(inout lhs: Population, rhs: Population) {
	lhs.members += rhs.members
}

public func +=(inout lhs: Population, rhs: [Individual]) {
	lhs.members += rhs
}