//
//  Population.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/28/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation
import Darwin

/**
An ordered collection of `Individual` objects.
*/
public struct Population: CollectionType, ArrayLiteralConvertible {
	
	// MARK: - Class Methods
	
	///
	public static func uniformSelection(count: Int) -> Population -> Population {
		return { population in
			let selectionIndices = uniformSelectionIndices(count)(population)
			return population.populationWithSelectionIndices(selectionIndices)
		}
	}
	
	///
	public static func uniformSelectionIndices(count: Int) -> Population -> Set<Int> {
		return { population in
			var selectedIndices = Set<Int>()
			var pool = (0..<population.count).map { $0 }
			let selectionCount = min(count, pool.count)
			
			for i in 0..<selectionCount {
				let index = Int(arc4random_uniform(UInt32(selectionCount - i)))
				selectedIndices.insert(pool.removeAtIndex(index))
			}
			
			return selectedIndices
		}
	}
	
	
	// MARK: - Initializers
	
	///
	public init(members: [Individual]) {
		self.members += members
	}
	
	/// Creates a new `Population` instance with a specified number of members and a func to generate each member.
	public init(size: Int, seed: () -> Individual) {
		for _ in 0..<size {
			members.append(seed())
		}
	}
	
	///
	public init(arrayLiteral elements: Individual...) {
		members += elements
	}
	
	
	// MARK: - Instance Properties
	
	/// The `Individual`s which comprise this population.
	public var members = [Individual]()
	
	/// An `Array` of the `Population`'s members paired by order into tuples.
	/// E.g., `[(members[0], members[1]), (members[2], members[3]),` ... `(members[count - 2], members[count - 1])]`.
	/// - Note: The implementation currently assumes that the population contains an even number of members.
	public var pairs: [(Individual, Individual)] {
		return 0.stride(through: count - 1, by: 2)
			.map { (self[$0], self[$0 + 1]) }
	}
	
	/// The total fitness of all `Individual`s in the population.
	public var totalFitness: Double {
		return members.map { $0.fitness }.reduce(0, combine: +)
	}
	
	public var averageFitness: Double {
		return totalFitness / Double(count)
	}
	
	// MARK: - Instance Methods
	
	/// Selects the top *n* members of the population ranked by fitness and returns them in a new population.
	/// - parameter elitistCount: The number of most-fit individuals to selected.
	/// - returns: A new `Population` containing the top *n* fitness-ranked members of `self` (where *n* is equal to `elitistCount`).
	public func elitismSelectionWithCount(elitistCount: Int) -> Population {
		var elitistPopulation = Population()
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
	
	/// Creates a new `Population` by applying *crossoverOperator* to each of this `Population`'s `pairs`.
	public func reproduceWithCrossover(crossoverOperator: CrossoverOperator) -> Population {
		var offspringPopulation = Population()
		
		for pair in pairs {
			let offspringPair = pair.0.reproduceWithCrossover(crossoverOperator, pairIndividual: pair.1)
			offspringPopulation += [offspringPair.0, offspringPair.1]
		}
		
		return offspringPopulation
	}

	/// Creates a new `Population` by applying *mutationOperator* to each of this `Population`'s `members`.
	public func reproduceWithMutation(mutationOperator: MutationOperator) -> Population {
		let mutatedMembers = map { $0.reproduceWithMutation(mutationOperator) }
		return Population(members: mutatedMembers)
	}
	
	/// Creates a new `Population` by applying *recombinationOperator* to each of this `Population`'s `pairs`.
	public func reproduceWithRecombination(recombinationOperator: RecombinationOperator) -> Population {
		let recombinedMembers = pairs.map { pair in
			pair.0.reproduceWithRecombination(recombinationOperator,
				pairIndividual: pair.1)
		}
		
		return Population(members: recombinedMembers)
	}
	
	/// Returns a new `Population` of a given size by selecting individuals from this population using the "roulette wheel" technique, optionally excluding certain members of this population from this process.
	public func rouletteWheelSelection(newPopulationSize newPopSize: Int? = nil, excludedIndices: Set<Int> = Set<Int>()) -> Population {
		var includedPopulation = self
		
		// Filter out excluded members (if any)
		for excludedIndex in excludedIndices {
			includedPopulation.members.removeAtIndex(excludedIndex)
		}
		
		// Select new members
		var selectedPopulation = Population()
		
		// Select individuals with odds proportional to their fitness.
		for _ in 0..<(newPopSize ?? members.count) {
			let selectedIndividual = includedPopulation.rouletteWheelSelect()
			selectedPopulation.append(selectedIndividual)
		}
		
		return selectedPopulation
	}
	
	/// Selects and returns an individual in this `Population` using the "roulette wheel" technique, which performs selection-with-replacement where the probability of an individual being selected is linearly proportional to its fitness.
	public func rouletteWheelSelect() -> Individual {
		// Seed the random double generator (once)
		var onceToken: dispatch_once_t = 0
		dispatch_once(&onceToken) { () -> Void in
			srand48(Int(arc4random()))
		}
		
		// Randomly generate a cumulative fitness ratio threshold
		let fitnessRatioThreshold = drand48()
		
		let totalFitness = self.totalFitness
		var selectionIndex = 0
		var selectionIndividual: Individual
		var fitnessRatioSum: Double = 0
		
		repeat {
			selectionIndividual = self[selectionIndex++]
			fitnessRatioSum += selectionIndividual.fitness / totalFitness
		} while fitnessRatioSum < fitnessRatioThreshold
		
		return selectionIndividual
	}
	
	/// Returns a `Population` instance comprised of the members of this population
	public func populationWithSelectionIndices(indices: Set<Int>) -> Population {
		var selectedPopulation = Population()
		
		for index in indices {
			selectedPopulation.append(self[index])
		}
		
		return selectedPopulation
	}
	
	/// Returns a `Population` instance comprised of this population's members, excluding the members at the specified indices.
	/// - param indices: The indices of the `Individuals` to exclude from the returned `Population`.
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
	public func selectionBranch(branchSelector: Population -> Set<Int>, branchHandler: (selected: Population, unselected: Population) -> (Population)) -> Population {
		let selectionIndices = branchSelector(self)
		let selectedPopulation = self.populationWithSelectionIndices(selectionIndices)
		let unselectedPopulation = self.populationWithExcludedIndices(selectionIndices)
		return branchHandler(selected: selectedPopulation, unselected: unselectedPopulation)
	}
	
	
	// MARK: - CollectionType
	
	public typealias Element = Individual
	
	public typealias Index = Int
	
	public typealias Generator = IndexingGenerator<[Individual]>
	
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

// MARK: - Operators

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