//
//  ConfigFileWriter.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 5/17/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

struct ConfigFileWriter {
	
	var config: ExperimentConfig
	
	var directoryPath: String
	
	var filename: String {
		return "Config.txt"
	}
	
	var filepath: String {
		return directoryPath + filename
	}
	
	func writeConfigFile() {
		let content = makeConfigFileContent()
		do {
			try content.writeToFile(filepath, atomically: true, encoding: NSUTF8StringEncoding)
		}
		catch let error as NSError {
			preconditionFailure("\(error)")
		}
	}
	
	func makeConfigFileContent() -> String {
		return "evolutionaryTaskCount: \(config.evolutionaryTaskCount)\n"
			+ "testTaskCount: \(config.testTaskCount)\n"
			+ "numberOfGenerations: \(config.evolutionConfig.numberOfGenerations)\n"
			+ "populationSize: \(config.environmentConfig.populationSize)\n"
			+ "learningRuleSize: \(config.fitnessConfig.learningRuleSize)\n"
			+ "numberOfTrainingEpochs: \(config.fitnessConfig.numberOfTrainingEpochs)\n"
			+ "elitismCount: \(config.reproductionConfig.elitismCount)\n"
			+ "crossoverRate: \(config.reproductionConfig.crossoverRate)\n"
			+ "mutationRate: \(config.reproductionConfig.mutationRate)"
	}
	
}
