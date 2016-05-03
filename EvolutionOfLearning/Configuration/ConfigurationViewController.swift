//
//  ConfigurationViewController.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/3/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Cocoa

class ConfigurationViewController: NSViewController {
	
	override func loadView() {
		super.loadView()
		
		view = ConfigurationView(frame: NSRect(x: 100, y: 100, width: 400, height: 600))
	}

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
