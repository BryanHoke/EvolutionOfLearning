//
//  Array-Extensions.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/14/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

/*
public extension Array where Element : GeneticIndividual {

public var totalFitness: Double {
return self.map { $0.fitness }.reduce(0, combine: +)
}

public func rouletteWheelSelection(newPopulationSize newPopulationSize: Int? = nil, excludedIndices: Set<Index> = Set<Index>()) -> Array<Element> {

func rouletteWheelSelect() -> GeneticIndividual {
let totalFitness = self.totalFitness
var onceToken: dispatch_once_t = 0
dispatch_once(&onceToken) { () -> Void in
srand48(Int(arc4random()))
}
let random = drand48()
var selectionIndex = 0
var selectionIndividual: GeneticIndividual
var fitnessRatioSum: Double = 0
repeat {
selectionIndividual = self[selectionIndex++]
fitnessRatioSum += selectionIndividual.fitness / totalFitness
} while fitnessRatioSum < random
return selectionIndividual
}
if !excludedIndices.isEmpty {
let filteredPopulation = self.filter { (element: Generator.Element) -> Bool in
//				guard let index: Index = self.indexOf(element) else {
//                    return false
//                }

return excludedIndices.contains(index)
}

}

var newPopulation = [Element]()
//
return newPopulation
}

}
*/