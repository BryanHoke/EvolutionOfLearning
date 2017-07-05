//
//  DocumentWindowController.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 2/24/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Cocoa

class DocumentWindowController: NSWindowController {

	@IBOutlet weak var runButton: NSButton!
	
	@IBOutlet weak var generationsTextField: NSTextField!
	
	@IBOutlet weak var trialsTextField: NSTextField!
	
	@IBAction func runButtonClicked(_ sender: NSButton) {
		eventHandler?.runButtonClicked()
	}
	
	var eventHandler: ControlEventHandler?
	
	override func controlTextDidChange(_ obj: Notification) {
		guard let textField = obj.object as? NSTextField else {
			return
		}
		
		let value = textField.integerValue
		
		// Assign the text field value to the respective experimental parameter
		if textField === generationsTextField {
			eventHandler?.numberOfGenerationsChanged(to: value)
		}
		else if textField === trialsTextField {
			eventHandler?.numberOfTrialsChanged(to: value)
		}
	}
	
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }

}
