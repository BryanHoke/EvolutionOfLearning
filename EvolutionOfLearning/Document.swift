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
	
	// MARK: - Instance Methods

	override func windowControllerDidLoadNib(aController: NSWindowController) {
		super.windowControllerDidLoadNib(aController)
		// Add any code here that needs to be executed once the windowController has loaded the document's window.
	}

	override class func autosavesInPlace() -> Bool {
		return true
	}

//	override var windowNibName: String? {
//		// Returns the nib file name of the document
//		// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
//		return "Document"
//	}
	
	override func makeWindowControllers() {
//		let documentController = DocumentWindowController(windowNibName: "Document")
//		addWindowController(documentController)
	}
	
	func writeExperiment() {
		print("writeExperiment")
//		do {
//			try managedObjectContext?.save()
//			var urlString = resultsPath + "/Results0.xml"
//			urlString = (urlString as NSString).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.whitespaceAndNewlineCharacterSet().invertedSet)!
//			let url = NSURL(fileURLWithPath: urlString)
//			try writeToURL(url, ofType: "XML", forSaveOperation: .SaveAsOperation, originalContentsURL: nil)
//		}
//		catch {
//			print("error: writeExperiment")
//		}
	}
	
}
