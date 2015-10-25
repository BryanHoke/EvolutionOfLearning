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
		
		eventHandler = ExperimentCoordinator()
		
		super.init()
		
		eventHandler.documentWasCreated(self)
		eventHandler.document(self, environmentPathChanged: environmentPath)
	}
	
	
	// MARK: - Instance Properties
	
	var eventHandler: DocumentEventHandler
	
	var dataManager: DataManager!
	
	var experiment: Experiment!
	
	///
	var basePath: String {
		return "/Users/bryanhoke/Projects/BDHSoftware/OS X/EvolutionOfLearning"
	}
	
	///
	var resourcePath: String {
		return basePath + "/Resources"
	}
	
	///
	var resultsPath: String {
		return basePath + "/Results"
	}
	
	var environmentPath: String {
		return resourcePath + "/Environment1.txt"
	}
	
	
	// MARK: Interface Builder Outlets
	
	@IBOutlet
	weak var runExperimentButton: NSButton!
	
	@IBOutlet
	weak var generationsTextField: NSTextField!
	
	@IBOutlet
	weak var trialsTextField: NSTextField!
	
	
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
	
	func writeExperiment() {
		do {
			try managedObjectContext?.save()
			let url = NSURL(string: resultsPath + "/Results0")!
			try writeToURL(url, ofType: "XML")
		}
		catch {
			
		}
	}
	
	
	// MARK: Control Editing Notifications
	
	override func controlTextDidChange(obj: NSNotification) {
		
		guard let textField = obj.object as? NSTextField else {
			return
		}
		
		let value = textField.integerValue
		
		// Assign the text field value to the respective experimental parameter
		if textField === generationsTextField {
			eventHandler.document(self, numberOfGenerationsChangedToValue: value)
		}
		else if textField === trialsTextField {
			eventHandler.document(self, numberOfTrialsChangedToValue: value)
		}
	}
	
	
	// MARK: Interface Builder Actions
	
	@IBAction
	func runExperimentButtonClicked(sender: NSButton) {
		eventHandler.runButtonClickedForDocument(self)
	}
}