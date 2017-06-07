//
//  AppDelegate.swift
//  DataAnalysis
//
//  Created by Bryan Hoke on 8/9/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Cocoa

private let externalBasePath = "/Volumes/Seagate Blue/Thesis/"
private let localBasePath = "/Users/bryanhoke/Projects/BDHSoftware/OS X/EvolutionOfLearning/"

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!


	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Insert code here to initialize your application
		
		let dataSetDirectory = localBasePath + "Results/Set 14/"
		
		do {
			let dataSet = try DataSetScanner.shared.scanDataSet(fromDirectoryAtPath: dataSetDirectory)
			try ColumnwiseDataSetRecorder.shared.write(dataSet, toDirectoryAtPath: dataSetDirectory)
		}
		catch let error as NSError {
			print(error)
		}
		
		
//		let experimentDirectory = "/Volumes/Seagate Blue/Thesis/Results/Set 11/Experiment 00/"
//		let overview = try! ExperimentScanner.shared.scanExperimentOverview(fromDirectoryAtPath: experimentDirectory)
		
//		let trialPath = "/Volumes/Seagate Blue/Thesis/Results/Set 11/Experiment 00/Trial 0.txt"
//		try! TrialScanner.shared.scanTrial(fromFileAtPath: trialPath)
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}


}

