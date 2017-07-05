//
//  ConfigurationWindowController.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 2/24/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Cocoa

class ConfigurationWindowController: NSWindowController, ExperimentInterface {
	
	typealias IndividualType = BasicIndividual<SegmentedChromosome>
	
	typealias Record = AnyTrialRecord<IndividualType>
	
	weak var eventHandler: ConfigurationEventHandling?

	@IBOutlet weak var conditionButton: NSPopUpButton!
	
	@IBOutlet weak var generationsField: NSTextField!
	
	@IBOutlet weak var trialsField: NSTextField!
	
	@IBOutlet weak var runButton: NSButton!
	
	@IBOutlet weak var tasksField: NSTextField!
	
	@IBOutlet weak var maxTasksField: NSTextField!
	
	@IBOutlet weak var tasksFormatter: NumberFormatter!
	
	@IBOutlet weak var maxTasksFormatter: NumberFormatter!
	
	@IBOutlet weak var fitnessIncludesTrainingSwitch: NSButton!
	
	@IBAction func runButtonClicked(_ sender: NSButton) {
		eventHandler?.runButtonPressed()
	}
	
	@IBAction func conditionButtonChanged(_ sender: NSPopUpButton) {
		eventHandler?.selectedConditionIndexChanged(to: sender.indexOfSelectedItem)
	}
	
	@IBAction func fitnessIncludesTrainingSwitchChanged(_ sender: NSButton) {
		eventHandler?.fitnessIncludesTrainingChanged(to: sender.state == NSOnState)
	}
	
	override func controlTextDidChange(_ obj: Notification) {
		guard let textField = obj.object as? NSTextField else {
			return
		}
		
		if textField === generationsField {
			eventHandler?.numberOfGenerationsChanged(to: numberOfGenerations)
		}
		else if textField === trialsField {
			eventHandler?.numberOfTrialsChanged(to: numberOfTrials)
		}
		else if textField === tasksField {
			eventHandler?.numberOfTasksChanged(to: numberOfTasks)
		}
		else if textField === maxTasksField {
			eventHandler?.maxNumberOfTasksChanged(to: maxNumberOfTasks)
		}
	}
	
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
		driver.recorder = recorder
		eventHandler = driver
		driver.interface = self
    }
	
	let driver = ExperimentDriver<IndividualType>()
	
	let recorder = ExperimentRecorder<Record>()
	
	// MARK: - ExperimentInterface
	
	var experimentalConditions: [String] {
		get {
			return conditionButton.itemTitles
		}
		set {
			conditionButton.removeAllItems()
			for condition in newValue {
				conditionButton.addItem(withTitle: condition)
			}
		}
	}
	
	var selectedConditionIndex: Int? {
		get {
			let index = conditionButton.indexOfSelectedItem
			return index >= 0 ? index : nil
		}
		set {
			conditionButton.selectItem(at: newValue ?? -1)
		}
	}
	
	var numberOfTrials: Int {
		get { return trialsField.integerValue }
		set { trialsField.integerValue = newValue }
	}
	
	var numberOfGenerations: Int {
		get { return generationsField.integerValue }
		set { generationsField.integerValue = newValue }
	}
	
	var numberOfTasks: Int {
		get { return tasksField.integerValue }
		set {
			tasksField.integerValue = newValue
		}
	}
	
	var numberOfTasksUpperBound: Int? {
		get { return tasksFormatter.maximum?.intValue }
		set {
			tasksFormatter.maximum = newValue as! NSNumber
			maxTasksFormatter.maximum = newValue as! NSNumber
		}
	}
	
	var maxNumberOfTasks: Int {
		get { return maxTasksField.integerValue }
		set { maxTasksField.integerValue = newValue }
	}
	
	var fitnessIncludesTraining: Bool {
		get { return fitnessIncludesTrainingSwitch.state == NSOnState }
		set { fitnessIncludesTrainingSwitch.state = newValue ? NSOnState : NSOffState }
	}
}
