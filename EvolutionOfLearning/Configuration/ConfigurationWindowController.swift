//
//  ConfigurationWindowController.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 2/24/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Cocoa

class ConfigurationWindowController: NSWindowController, ExperimentInterface {
	
	weak var eventHandler: ConfigurationEventHandling?

	@IBOutlet weak var conditionButton: NSPopUpButton!
	
	@IBOutlet weak var generationsField: NSTextField!
	
	@IBOutlet weak var trialsField: NSTextField!
	
	@IBOutlet weak var runButton: NSButton!
	
	@IBAction func runButtonClicked(sender: NSButton) {
		eventHandler?.runButtonPressed()
	}
	
	@IBAction func conditionButtonChanged(sender: NSPopUpButton) {
		eventHandler?.selectedConditionIndexChanged(to: sender.indexOfSelectedItem)
	}
	
	override func controlTextDidChange(obj: NSNotification) {
		guard let textField = obj.object as? NSTextField else {
			return
		}
		
		if textField === generationsField {
			eventHandler?.numberOfGenerationsChanged(to: numberOfGenerations)
		}
		else if textField === trialsField {
			eventHandler?.numberOfTrialsChanged(to: numberOfTrials)
		}
	}
	
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
	
	// MARK: - ExperimentInterface
	
	var experimentalConditions: [String] {
		get {
			return conditionButton.itemTitles
		}
		set {
			conditionButton.removeAllItems()
			for condition in newValue {
				conditionButton.addItemWithTitle(condition)
			}
		}
	}
	
	var selectedConditionIndex: Int? {
		get {
			let index = conditionButton.indexOfSelectedItem
			return index >= 0 ? index : nil
		}
		set {
			conditionButton.selectItemAtIndex(newValue ?? -1)
		}
	}
	
	var numberOfTrials: Int {
		get {
			return trialsField.integerValue
		}
		set {
			trialsField.integerValue = newValue
		}
	}
	
	var numberOfGenerations: Int {
		get {
			return generationsField.integerValue
		}
		set {
			generationsField.integerValue = newValue
		}
	}
	
}
