//
//  DataFetcher.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 2/20/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

protocol DataFetcher {
	
	associatedtype ChromosomeType : Chromosome
	
	func fetchMostFitChromosome() -> ChromosomeType
	
}
