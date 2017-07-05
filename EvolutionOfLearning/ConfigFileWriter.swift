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
	
	func write(_ config: ExperimentConfig, inDirectory directoryPath: String) {
		let content = makeFileContent(for: config)
		let path = "\(directoryPath)/\(filename)"
		
		do {
			try content.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
		}
		catch let error as NSError {
			preconditionFailure("\(error)")
		}
	}
	
	func makeFileContent(for config: ExperimentConfig) -> String {
		return config.outputDescription
	}
	
}
