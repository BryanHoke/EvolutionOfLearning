//
//  AppDelegate.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 6/13/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	var configurationWindowController: ConfigurationWindowController!

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Insert code here to initialize your application
		configurationWindowController = ConfigurationWindowController(windowNibName: "ConfigurationWindowController")
		configurationWindowController.window?.makeKeyAndOrderFront(self)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

}
