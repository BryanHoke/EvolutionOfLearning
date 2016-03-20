//
//  Population.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/28/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation
import Darwin

/// An ordered collection of `Individual`s.
public struct Population {
	
	public init(members: [Individual]) {
		self.members = members
	}
	
	/// Creates a new `Population` instance with a specified number of members and a func to generate each member.
	public init(size: Int, seed: () -> Individual) {
		members = (0..<size).map { _ in
			seed()
		}
	}
	
	/// The `Individual`s which comprise this population.
	public var members: [Individual] = []
	
}

// MARK: - Computed Properties

extension Population {
	
	/// An `Array` of the `Population`'s members paired by order into tuples.
	///
	/// E.g., `[(members[0], members[1]), (members[2], members[3]),` ... `(members[count - 2], members[count - 1])]`.
	///
	/// - Note: The implementation currently assumes that the population contains an even number of members.
	public var pairs: [(Individual, Individual)] {
		return 0
			.stride(through: count - 1, by: 2)
			.map { (self[$0], self[$0 + 1]) }
	}
	
	/// The total fitness of all `Individual`s in the population.
	public var totalFitness: Double {
		return members.map { $0.fitness }.reduce(0, combine: +)
	}
	
	/// The average fitness of the members in `self`.
	public var averageFitness: Double {
		return totalFitness / Double(count)
	}
	
}

// MARK: - Instance Methods

extension Population {
	
	/// Applies a mutating block to each member in `self`.
	public mutating func visitMembers(using block: (inout member: Individual) -> Void) {
		for i in indices {
			block(member: &members[i])
		}
	}
	
	/// Returns a `Population` containing the top *elitistCount* members of `self`, as indicated by fitness.
	public func elitistSelection(using elitistCount: Int) -> Population {
		var elitistPopulation = Population()
		for index in 0..<elitistCount {
			elitistPopulation.append(self[index])
		}
		return elitistPopulation
	}
	
	/// Returns a `Population` created by applying *crossoverOperator* to each pair of members in `self`.
	public func reproduceWithCrossover(crossoverOperator: CrossoverOperator) -> Population {
		var offspringPopulation = Population()
		
		for pair in pairs {
			let offspringPair = crossover(pair, using: crossoverOperator)
			offspringPopulation += [offspringPair.0, offspringPair.1]
		}
		
		return offspringPopulation
	}

	/// Returns a `Population` created by applying *mutationOperator* to each member in `self`.
	public func reproduceWithMutation(mutationOperator: MutationOperator) -> Population {
		let mutatedMembers = map { mutate($0, using: mutationOperator) }
		return Population(members: mutatedMembers)
	}
	
	/// Return a new `Population` created by applying *recombinationOperator* to each pair of members in `self`.
	public func reproduceWithRecombination(recombinationOperator: RecombinationOperator) -> Population {
		let recombinedMembers = pairs.map { pair in
			recombine(pair, using: recombinationOperator)
		}
		
		return Population(members: recombinedMembers)
	}
	
	/// Returnes a `Population` created by cloning the members in `self`.
	public func reproduceWithCloning() -> Population {
		let clonedMembers = map(clone)
		return Population(members: clonedMembers)
	}
	
	/// Returns a new `Population` of a given size by selecting individuals from `self` using "roulette wheel" selection, optionally excluding certain members of this population from this process.
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
	
	/// Returns an individual selected from `self` using roulette wheel selection.
	///
	/// Roulette wheel selection is a replacing selection where the probability of an individual being selected is linearly proportional to its fitness.
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
	
	/// Returns a `Population` by selecting the members in `self` at the specified *indices*.
	public func populationWithSelectionIndices(indices: Set<Int>) -> Population {
		var selectedPopulation = Population()
		
		for index in indices {
			selectedPopulation.append(self[index])
		}
		
		return selectedPopulation
	}
	
	/// Returns a `Population` by selecting the members in `self` *not* at the specified *indices*.
	///
	/// - param indices: The indices of the `Individuals` to exclude from the returned `Population`.
	public func populationWithExcludedIndices(indices: Set<Int>) -> Population {
		var allIndices = Set<Int>()
		for i in 0..<count {
			allIndices.insert(i)
		}
		let selectionIndices = allIndices.subtract(indices)
		return self.populationWithSelectionIndices(selectionIndices)
	}
	
	/// Returns a Population containing *count* members uniformly selected from `self`.
	///
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
	
	/// Returns a population by partitioning `self` using *brancSelector* and then combining the partitions using *branchCombine*.
	public func selectionBranch(branchSelector: Population -> Set<Int>, branchCombine: (selected: Population, unselected: Population) -> (Population)) -> Population {
		let selectionIndices = branchSelector(self)
		let selectedPopulation = self.populationWithSelectionIndices(selectionIndices)
		let unselectedPopulation = self.populationWithExcludedIndices(selectionIndices)
		return branchCombine(selected: selectedPopulation, unselected: unselectedPopulation)
	}
}

// MARK: - Type Methods

extension Population {
	
	public static func uniformSelection(count: Int) -> Population -> Population {
		return { population in
			let selectionIndices = uniformSelectionIndices(count)(population)
			return population.populationWithSelectionIndices(selectionIndices)
		}
	}
	
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
	
}

// MARK: - ArrayLiteralConvertible

extension Population: ArrayLiteralConvertible {
	
	public init(arrayLiteral elements: Individual...) {
		members = elements
	}
	
}

// MARK: - CollectionType

extension Population: CollectionType {
	
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