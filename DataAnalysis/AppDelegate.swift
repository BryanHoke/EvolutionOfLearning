//
//  AppDelegate.swift
//  DataAnalysis
//
//  Created by Bryan Hoke on 8/9/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Cocoa

/// The index of the result set to analyze.
private let setIndex = 14
/// Whether average values will be written (as opposed to raw values).
private let shouldWriteAverages = false

private let externalBasePath = "/Volumes/Seagate Blue/Thesis/"
private let localBasePath = "/Users/bryanhoke/Projects/BDHSoftware/OS X/EvolutionOfLearning/"

private func isTesting() -> Bool {
	return ProcessInfo.processInfo.environment["XCInjectBundleInto"] != nil
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	@IBOutlet weak var window: NSWindow!


	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		
		guard !isTesting() else {
			return
		}
		
		let dataSetDirectory = externalBasePath + "Results/Set \(setIndex)/"
		
		do {
			let dataSet: DataSet
			if shouldWriteAverages {
				dataSet = try DataSetScanner.shared.scanDataSet(fromDirectoryAtPath: dataSetDirectory)
			}
			else {
				dataSet = try DataSetScanner.shared.scanDataSetRecord(fromDirectoryAtPath: dataSetDirectory)
			}
			try DataSetRecorder.columnwise.write(dataSet, toDirectoryAtPath: dataSetDirectory)
		}
		catch let error as NSError {
			print(error)
		}
		
		
//		let experimentDirectory = "/Volumes/Seagate Blue/Thesis/Results/Set 11/Experiment 00/"
//		let overview = try! ExperimentScanner.shared.scanExperimentOverview(fromDirectoryAtPath: experimentDirectory)
		
//		let trialPath = "/Volumes/Seagate Blue/Thesis/Results/Set 11/Experiment 00/Trial 0.txt"
//		try! TrialScanner.shared.scanTrial(fromFileAtPath: trialPath)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

