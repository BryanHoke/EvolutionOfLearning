//
//  ConfigurationView.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/1/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Cocoa

class ConfigurationView: NSView {
	
	override init(frame frameRect: NSRect) {
		stackView = NSStackView(views: [elitismField, crossoverField, mutationField, populationSizeField, generationsField, trialsField, runButton])
		
		super.init(frame: frameRect)
		
		addSubview(stackView)
		stackView.frame = bounds
		
		stackView.autoresizingMask = [.viewWidthSizable, .viewHeightSizable]
		
//		stackView.translatesAutoresizingMaskIntoConstraints = false
//		stackView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
//		stackView.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
//		stackView.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
//		stackView.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
		
		stackView.orientation = .vertical
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	let elitismField = NSTextField()
	
	let crossoverField = NSTextField()
	
	let mutationField = NSTextField()
	
	let populationSizeField = NSTextField()
	
	let generationsField = NSTextField()
	
	let trialsField = NSTextField()
	
	let runButton = NSButton()
	
	fileprivate let stackView: NSStackView
    
}
