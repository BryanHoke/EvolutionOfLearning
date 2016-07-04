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
	
	@IBOutlet weak var tasksFormatter: NSNumberFormatter!
	
	@IBOutlet weak var maxTasksFormatter: NSNumberFormatter!
	
	@IBOutlet weak var fitnessIncludesTrainingSwitch: NSButton!
	
	@IBAction func runButtonClicked(sender: NSButton) {
		eventHandler?.runButtonPressed()
	}
	
	@IBAction func conditionButtonChanged(sender: NSPopUpButton) {
		eventHandler?.selectedConditionIndexChanged(to: sender.indexOfSelectedItem)
	}
	
	@IBAction func fitnessIncludesTrainingSwitchChanged(sender: NSButton) {
		eventHandler?.fitnessIncludesTrainingChanged(to: sender.state == NSOnState)
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
		runner.recorder = recorder
		let driver = ExperimentDriver(experimentRunner: runner)
		self.driver = driver
		eventHandler = driver
		driver.interface = self
    }
	
	let runner = ExperimentRunner<IndividualType>()
	
	let recorder = ExperimentRecorder<Record>()
	
	var driver: ExperimentDriver?
	
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
		get { return tasksFormatter.maximum?.integerValue }
		set {
			tasksFormatter.maximum = newValue
			maxTasksFormatter.maximum = newValue
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
