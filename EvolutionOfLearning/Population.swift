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
public struct Population<Member : Individual> : ArrayLiteralConvertible {
	
	public typealias PopulationType = Population<Member>
	
	public typealias ChromosomeType = Member.ChromosomeType
	
	public typealias MemberPair = (Member, Member)
	
	public typealias CrossoverOperator = (ChromosomeType, ChromosomeType) -> (ChromosomeType, ChromosomeType)
	
	public typealias MutationOperator = (ChromosomeType) -> ChromosomeType
	
	public typealias RecombinationOperator = (ChromosomeType, ChromosomeType) -> ChromosomeType
	
	/// The `Individual`s which comprise this population.
	public var members: [Member] = []
	
	public init(members: [Member]) {
		self.members = members
	}
	
	/// Creates a new `Population` instance with a specified number of members and a func to generate each member.
	public init(size: Int, seed: () -> Member) {
		members = (0..<size).map { _ in
			seed()
		}
	}
	
	public init() {}
	
	public init(arrayLiteral elements: Member...) {
		members = elements
	}
	
}

// MARK: - Computed Properties

extension Population {
	
	/// An `Array` of the `Population`'s members paired by order into tuples.
	///
	/// E.g., `[(members[0], members[1]), (members[2], members[3]),` ... `(members[count - 2], members[count - 1])]`.
	///
	/// - Note: The implementation currently assumes that the population contains an even number of members.
	public var pairs: [MemberPair] {
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
	public mutating func visitMembers(using block: (inout member: Member) -> Void) {
		for i in indices {
			block(member: &members[i])
		}
	}
	
	/// Mutates the members in `self` using a specified *mutationRate*.
	public mutating func mutateInPlace(using mutationRate: Double) {
		visitMembers { (inout member: Member) in
			member.chromosome.mutate(withRate: mutationRate)
		}
	}
	
	/// Returns a `Population` containing the top *elitistCount* members of `self`, as indicated by fitness.
	public func elitistSelection(using elitistCount: Int) -> PopulationType {
		var elitistPopulation = Population()
		for index in 0..<elitistCount {
			elitistPopulation.append(self[index])
		}
		return elitistPopulation
	}
	
	/// Returns a `Population` created by applying *crossoverOperator* to each pair of members in `self`.
	public func reproduceWithCrossover(crossoverOperator: CrossoverOperator) -> PopulationType {
		var offspringPopulation = PopulationType()
		
		for pair in pairs {
			let offspringPair = Member.crossover(pair, using: crossoverOperator)
			offspringPopulation += [offspringPair.0, offspringPair.1]
		}
		
		return offspringPopulation
	}

	/// Returns a `Population` created by applying *mutationOperator* to each member in `self`.
	public func reproduceWithMutation(mutationOperator: MutationOperator) -> PopulationType {
		let mutatedMembers = map { Member.mutate($0, using: mutationOperator) }
		return Population(members: mutatedMembers)
	}
	
	/// Return a new `Population` created by applying *recombinationOperator* to each pair of members in `self`.
	public func reproduceWithRecombination(recombinationOperator: RecombinationOperator) -> PopulationType {
		let recombinedMembers = pairs.map { pair in
			Member.recombine(pair, using: recombinationOperator)
		}
		
		return Population(members: recombinedMembers)
	}
	
	/// Returnes a `Population` created by cloning the members in `self`.
	public func reproduceWithCloning() -> PopulationType {
		let clonedMembers = map(Member.clone)
		return PopulationType(members: clonedMembers)
	}
	
	/// Returns a new `Population` of a given size by selecting individuals from `self` using "roulette wheel" selection, optionally excluding certain members of this population from this process.
	public func rouletteWheelSelection(newPopulationSize newPopSize: Int? = nil, excludedIndices: Set<Int> = Set<Int>()) -> PopulationType {
		var includedPopulation = self
		
		// Filter out excluded members (if any)
		for excludedIndex in excludedIndices {
			includedPopulation.members.removeAtIndex(excludedIndex)
		}
		
		// Select new members
		var selectedPopulation = PopulationType()
		
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
	public func rouletteWheelSelect() -> Member {
		// Seed the random double generator (once)
		var onceToken: dispatch_once_t = 0
		dispatch_once(&onceToken) { () -> Void in
			srand48(Int(arc4random()))
		}
		
		// Randomly generate a cumulative fitness ratio threshold
		let fitnessRatioThreshold = drand48()
		
		let totalFitness = self.totalFitness
		var selectionIndex = 0
		var selectionIndividual: Member
		var fitnessRatioSum: Double = 0
		
		repeat {
			selectionIndividual = self[selectionIndex]
			selectionIndex += 1
			fitnessRatioSum += selectionIndividual.fitness / totalFitness
		} while fitnessRatioSum < fitnessRatioThreshold
		
		return selectionIndividual
	}
	
	/// Returns a `Population` by selecting the members in `self` at the specified *indices*.
	public func populationWithSelectionIndices(indices: Set<Int>) -> PopulationType {
		var selectedPopulation = PopulationType()
		
		for index in indices {
			selectedPopulation.append(self[index])
		}
		
		return selectedPopulation
	}
	
	/// Returns a `Population` by selecting the members in `self` *not* at the specified *indices*.
	///
	/// - param indices: The indices of the `Individuals` to exclude from the returned `Population`.
	public func populationWithExcludedIndices(indices: Set<Int>) -> PopulationType {
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
	public func populationWithUniformSelection(count: Int) -> PopulationType {
		var newPopulation = PopulationType()
		var pool = self
		let newPopulationSize = min(count, pool.count)
		
		for i in 0..<newPopulationSize {
			let index = Int(arc4random_uniform(UInt32(newPopulationSize - i)))
			newPopulation.append(pool.members.removeAtIndex(index))
		}
		
		return newPopulation
	}
	
	/// Returns a population by partitioning `self` using *branchSelector* and then combining the partitions using *branchCombine*.
	public func selectionBranch(branchSelector: (PopulationType) -> Set<Int>, branchCombine: (selected: PopulationType, unselected: PopulationType) -> (PopulationType)) -> PopulationType {
		let selectionIndices = branchSelector(self)
		let selectedPopulation = self.populationWithSelectionIndices(selectionIndices)
		let unselectedPopulation = self.populationWithExcludedIndices(selectionIndices)
		return branchCombine(selected: selectedPopulation, unselected: unselectedPopulation)
	}
}

// MARK: - Type Methods

extension Population {
	
	public static func uniformSelection(count: Int) -> PopulationType -> PopulationType {
		return { population in
			let selectionIndices = uniformSelectionIndices(count)(population)
			return population.populationWithSelectionIndices(selectionIndices)
		}
	}
	
	public static func uniformSelectionIndices(count: Int) -> PopulationType -> Set<Int> {
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

// MARK: - CollectionType

extension Population : CollectionType {
	
	public typealias Element = Member
	
	public typealias Index = Int
	
	public typealias Generator = IndexingGenerator<[Member]>
	
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
	
	public mutating func append(newElement: Member) {
		members.append(newElement)
	}
	
	public mutating func extend(newElements: [Member]) {
		members.appendContentsOf(newElements)
	}
	
	public func generate() -> IndexingGenerator<[Member]> {
		return members.generate()
	}
	
	public mutating func reserveCapacity(n: Int) {
		members.reserveCapacity(n)
	}
	
	public subscript(index: Int) -> Member {
		get {
			return members[index]
		}
		set {
			members[index] = newValue
		}
	}
	
}

// MARK: - Operators

public func +<Member : Individual>(lhs: Population<Member>, rhs: Population<Member>) -> Population<Member> {
	return lhs + rhs.members
}

public func +<Member : Individual>(lhs: Population<Member>, rhs: [Member]) -> Population<Member> {
	var newPopulation = lhs
	newPopulation.members += rhs
	return newPopulation
}

public func +=<Member : Individual>(inout lhs: Population<Member>, rhs: Population<Member>) {
	lhs.members += rhs.members
}

public func +=<Member : Individual>(inout lhs: Population<Member>, rhs: [Member]) {
	lhs.members += rhs
}