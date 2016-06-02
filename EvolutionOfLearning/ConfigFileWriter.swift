//
//  ConfigFileWriter.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/17/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

struct ConfigFileWriter {
	
	let filename = "Config.txt"
	
	func write(config: ExperimentConfig, inDirectory directoryPath: String) {
		let content = makeFileContent(for: config)
		let path = "\(directoryPath)/\(filename)"
		
		do {
			try content.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding)
		}
		catch let error as NSError {
			preconditionFailure("\(error)")
		}
	}
	
	func makeFileContent(for config: ExperimentConfig) -> String {
		return config.outputDescription
	}
	
}
