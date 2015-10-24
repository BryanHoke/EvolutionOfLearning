//
//  DocumentEventHandler.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 10/24/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

protocol DocumentEventHandler {
	
	func documentWasCreated(doc: Document)
	
	func document(doc: Document,
		environmentPathChanged path: String)
	
	func document(doc: Document,
		resultsPathChanged path: String)
	
	func document(doc: Document,
		numberOfGenerationsChangedToValue value: Int)
	
	func document(doc: Document,
		numberOfTrialsChangedToValue value: Int)
	
	func runButtonClickedForDocument(doc: Document)
}