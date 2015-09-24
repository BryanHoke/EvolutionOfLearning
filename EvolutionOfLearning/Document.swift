//
//  Document.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/13/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Cocoa

class Document: NSPersistentDocument {
	
	// MARK: - Initializers

	override init() {
		
		super.init()
		
		dataManager = ManagedDataManager(context: managedObjectContext!, model: managedObjectModel!)
		
		experiment = Experiment()
		
		experiment.dataManager = dataManager
	}
	
	// MARK: - Instance Properties
	
	var dataManager: DataManager!
	
	var experiment: Experiment!
	
	// MARK: Interface Builder Outlets
	
	@IBOutlet weak var runExperimentButton: NSButton!
	
	@IBOutlet weak var generationsTextField: NSTextField!
	
	@IBOutlet weak var trialsTextField: NSTextField!
	
	// MARK: - Instance Methods

	override func windowControllerDidLoadNib(aController: NSWindowController) {
		super.windowControllerDidLoadNib(aController)
		// Add any code here that needs to be executed once the windowController has loaded the document's window.
	}

	override class func autosavesInPlace() -> Bool {
		return true
	}

	override var windowNibName: String? {
		// Returns the nib file name of the document
		// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
		return "Document"
	}
	
	// MARK: Control Editing Notifications
	
	override func controlTextDidChange(obj: NSNotification) {
		
	}
	
	// MARK: Interface Builder Actions
	
	@IBAction func runExperimentButtonClicked(sender: NSButton) {
		
		
	}
}