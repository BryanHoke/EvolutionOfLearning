//
//  CustomOperators.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/14/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

infix operator ⚬ { }

/// Function composition operator.
func ⚬<A, B, C>(lhs: A -> B, rhs: B -> C) -> A -> C {
	return { (input: A) -> (C) in
		return rhs(lhs(input))
	}
}

func ⚬<A, B, C>(lhs: A -> B?, rhs: B -> C) -> A -> C? {
	return { (input: A) -> (C?) in
		guard let lhsOut = lhs(input) else {
			return nil
		}
		return rhs(lhsOut)
	}
}