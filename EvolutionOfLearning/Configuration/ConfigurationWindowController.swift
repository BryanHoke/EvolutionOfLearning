//
//  ConfigurationWindowController.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 2/24/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Cocoa

class ConfigurationWindowController: NSWindowController {
	
	weak var eventHandler: ConfigurationEventHandling?

	@IBOutlet weak var conditionButton: NSPopUpButton!
	
	@IBOutlet weak var generationsField: NSTextField!
	
	@IBOutlet weak var trialsField: NSTextField!
	
	@IBOutlet weak var runButton: NSButton!
	
	@IBAction func runButtonClicked(sender: NSButton) {
		eventHandler?.runButtonPressed()
	}
	
	@IBAction func conditionButtonChanged(sender: NSPopUpButton) {
		eventHandler?.selectedConditionChanged(to: sender.titleOfSelectedItem!)
	}
	
	override func controlTextDidChange(obj: NSNotification) {
		guard let textField = obj.object as? NSTextField else {
			return
		}
		
		let value = textField.integerValue
		
		if textField === generationsField {
			eventHandler?.numberOfGenerationsChanged(to: value)
		}
		else if textField === trialsField {
			eventHandler?.numberOfTrialsChanged(to: value)
		}
	}
	
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}
