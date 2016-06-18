//
//  EvolutionOfLearningTests.swift
//  EvolutionOfLearningTests
//
//  Created by Bryan Hoke on 6/13/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import XCTest
//import EvolutionOfLearning
import GameplayKit

class EvolutionOfLearningTests: XCTestCase {
	
	let inputSize = 8
	
	let activation = sigmoid(λ: 1.0)
	
	var randomInputSeed: NSData {
		let seed = "input"
		return seed.dataUsingEncoding(seed.fastestEncoding)!
	}
	
	var randomInputSource: GKRandomSource {
		return GKARC4RandomSource(seed: randomInputSeed)
	}
	
	var randomInputDistribution: GKRandom {
		return GKRandomDistribution(randomSource: randomInputSource, lowestValue: 0, highestValue: 1)
	}
	
	var randomWeightSeed: NSData {
		let seed = "weight"
		return seed.dataUsingEncoding(seed.fastestEncoding)!
	}
	
	var randomWeightSource: GKRandomSource {
		return GKARC4RandomSource(seed: randomWeightSeed)
	}
	
	var randomWeightDistribution: GKRandom {
		return GKRandomDistribution(randomSource: randomWeightSource, lowestValue: -1, highestValue: 1)
	}
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
	
	func makeRandomInputs() -> [Double] {
		var inputs = [Double]()
		let randomInputs = randomInputDistribution
		for _ in 0..<inputSize {
			let input: Double = randomInputs.nextBool() ? 1.0 : 0.0
			inputs.append(input)
		}
		return inputs
	}
	
	func makeRandomWeights() -> [Double] {
		var weights = [Double]()
		let randomWeights = randomWeightDistribution
		for _ in 0..<inputSize {
			let weight = Double(randomWeights.nextUniform())
			weights.append(weight)
		}
		return weights
	}
	
	func testSingleLayerSingleOutputNeuralNetworkPerformance() {
		let inputs = makeRandomInputs(), weights = makeRandomWeights()
		measureBlock() {
			let network = SingleLayerSingleOutputNeuralNetwork(weights: weights, activation: self.activation)
			network.activateWithInputs(inputs)
		}
	}
	
	func testSingleLayerSingleOutputFFNNPerformance() {
		let inputs = makeRandomInputs(), weights = makeRandomWeights()
		measureBlock() {
			let network = SingleLayerSingleOutputFFNN(weights: weights, activation: self.activation)
			network.activateWithInputs(inputs)
		}
	}
	
	func testSingleLayerNeuralNetworkPerformance() {
		let inputs = makeRandomInputs(), weights = [makeRandomWeights()]
		measureBlock() {
			let network = SingleLayerNeuralNetwork(weights: weights, activation: self.activation)
			network.activateWithInputs(inputs)
		}
	}
	
	func testSingleLayerNeuralNetworks() {
		let inputSize = 8
		let activation = sigmoid(λ: 1.0)
		var inputs = [Double]()
		var weights = [Double]()
		for _ in 0..<inputSize {
			inputs.append(randomDouble())
			weights.append(randomDouble())
		}
		var output1: Double = 0
		var output2: Double = 0
		let network1 = SingleLayerSingleOutputNeuralNetwork(weights: weights, activation: activation)
		output1 = network1.activateWithInputs(inputs)
		let network2 = SingleLayerNeuralNetwork(weights: [weights], activation: activation)
		output2 = network2.activateWithInputs(inputs)[0]
		XCTAssertEqual(output1, output2, "The network outputs \(output1) and \(output2) are not equal.")
	}
	
	let deltaRuleBits: [Bool] = [
		1, 1, 0, 1, 1,
		0, 0, 0,
		0, 0, 0,
		0, 0, 0,
		0, 0, 0,
		0, 0, 0,
		0, 0, 0,
		0, 0, 0,
		0, 1, 0,
		1, 1, 0,
		0, 0, 0
	]
	
	let deltaRuleCoefficients: [Double] = [
		4, 0, 0, 0, 0, 0, 0, 0, -2, 2, 0
	]
	
	let environmentPath = "/Users/bryanhoke/Projects/BDHSoftware/OS X/EvolutionOfLearning/Resources/Environment1.txt"

	func testChalmersLearningRule() {
		// Test rule initialization
		let rule = ChalmersLearningRule(bits: deltaRuleBits)
		XCTAssertEqual(rule.coefficients, deltaRuleCoefficients)
		
		guard
			let tasks = try? TaskParser().tasks(withFileAt: environmentPath),
			let task = tasks.first else {
			return
		}
		
		var network = SingleLayerSingleOutputNeuralNetwork(
			size: task.inputCount + 1,
			activation: sigmoid(λ: 1)) as FeedForwardNeuralNetwork
		
		let error1 = network.testOnTask(task) / Double(task.patterns.count)
		
		rule.trainNetwork(&network, task: task, numberOfTimes: 10)
		
		let error2 = network.testOnTask(task) / Double(task.patterns.count)
		
		XCTAssert(error1 > error2)
	}
	
	func testRequiredTaskPrecision() {
		let rule = ChalmersLearningRule(bits: deltaRuleBits)
		
		guard let tasks = try? TaskParser().tasks(withFileAt: environmentPath) else {
			return
		}
		
		for task in tasks {
			print("Task \(task.id)")
			print(task)
			var network = SingleLayerSingleOutputNeuralNetwork(
				size: task.inputCount + 1,
				activation: sigmoid(λ: 1)) as FeedForwardNeuralNetwork
			rule.trainNetwork(&network, task: task, numberOfTimes: 100)
			print(network)
			let fitness = 1 - network.testOnTask(task) / Double(task.patterns.count)
			print(fitness)
			print("\n")
		}
	}
	
	func testTaskSolutionPrecision() {
		let weightsForTaskID: DictionaryLiteral<Int, [Double]> = [
			// -29.3051203275098 -29.3051206608555 -29.3051209941627 -43.8138318340726
			0: [-32, -32, -32, -32],
			// -0.405976449015117 32.8530044230897 -0.405981002582318 15.8177078008302
			1: [-0.5, -32, -0.5, -16],
			// 18.2043315060886 14.2571702267054 -14.1496742882209 9.32694009950334
			2: [16, 16, -16, 8],
			// 14.4025764727585 -19.6388656783893 -14.4419956430523 -9.98631226276286
			3: [16, -16, -16, -8],
			// 16.5577124887878 0.695516559313457 -15.200740582007 -5.28062340346662
			4: [16, 1, -16, -4],
			// 27.6081250612209 -55.2627984101854 -27.2026927281923 -41.1556683933363
			5: [32, -32, -32, -32],
			// 12.8592908663853 -2.42225937071696 4.53194630580855
			6: [16, -2, 4],
			// -2.85130702625489 13.2163457348111 4.9179893400584
			7: [-2, 16, 4],
			// 7.79842554764741 8.78994235484789 3.71278779741178
			8: [8, 8, 4],
			// -8.75299194950575 8.55803024138924 -4.62952189164715
			9: [-8, 8, -4],
			// 1.28934747441415 -6.68339777965237 7.66289181855829 -15.1375622205403 -0.115800364367946
			10: [1, -8, 8, -16, 0],
			// 15.4235921031822 -4.31570051364756 18.6807666884852 -15.9836371675348 7.74281316314388
			11: [16, -4, 16, -16, 8],
			// 3.56706903362943 8.43860269110678 -20.0 0.468851538647057 -1.84137287135051
			// 3.38153073938142 4.80209970167464 -35.6431081010528 1.33874746131838 -10.7324179377614
			12: [4, 8, -16, 0.5, -2],
			// 30.5613472715287 -28.3470562331688 -15.8831582883624 -12.6845196073357 -42.8749532847402
			13: [32, -32, -16, -16, -32],
			// 1.74508563679626 20.0 -8.04715016243073 -6.62080666311994 0.263478118615417
			// -4.66485450532212 36.502629678918 -5.32395633433743 -5.31636504608712 5.86359262774119
			14: [2, 16, -8, -8, 0.5],
			// -3.60927742791478 17.4439900747952 20.0 -11.9965780024605 -4.35927431529024
			// -1.23830417106898 30.5901389334833 29.1033205244064 -35.8515430739051 8.15113659573228
			15: [-4, 16, 16, -8, -4],
			// -36.3705803432886 -29.1150779689955 28.5595622497748 28.5595258599506 6.85010365500213
			16: [-16, -16, 16, 16, 8],
			// 28.6572884366397 30.6561688425665 28.6573019440091 -29.0857437696723 14.0193090390523
			17: [32, 32, 32, -32, 16],
			// 15.8447745358609 -18.8352075706394 28.2731199780929 -5.82522308779397 42.1243230045131 24.0925152930912
			18: [16, -16, 32, -4, 32, 32],
			// 9.19311692179061 2.51441285987812 -14.677414040583 -7.06836121103146 -14.7544655168289 7.31034567253537
			19: [8, 2, -16, -8, -16, 8],
			// -22.149954244102 33.3574705881289 -16.7379603517304 -0.821592158766179 -27.5933037941686 3.81632376866296
			20: [-16, 32, -16, -1, -32, 4],
			// 14.5483731408877 8.34290448157202 -20.0 -5.72570393540755 -3.1243279783307 3.677643947318
			21: [16, 8, -16, -4, -4, 4],
			// -52.8152760620597 52.7147799896116 -25.944080836763 79.1339740563255 -5.26307449191241 13.5059069515931
			// -37.8331496657347 25.9932469883634 -13.7099798882927 50.0343887816782 -8.24518635922744 5.68690009413333
			// -36.8379040307977 32.5052500197112 -12.8710754805509 49.7677378741732 0.640530452885168 6.70768759899585
//			22: [-64, 64, -32, 64, -4, 16],
			22: [-32, 32, -16, 32, -8, 8],
			// -0.732404926761604 10.4838048622525 -10.0187755078872 -20.0 -9.02510260307061 -5.72369477589344
			23: [-1, 8, -8, -16, -8, -4],
			// -4.85760282957562 16.1124742356757 -15.7403154839309 -31.2735865351294 -10.2452012147766 -15.1695559327039
			24: [-4, 16, -16, -32, -8, -16],
			// 2.83220293775723 1.94449127769532 -15.6628772948847 -13.6889968573981 -0.356359565401016 -18.3253363000724
			25: [2, 2, -16, -16, -0.5, -16],
			// -13.0452273124718 16.9196515067615 16.6815155689308 18.3236999071856 5.76654162544836 -6.09897144822739 -1.91440081939959 17.054956290627
			26: [-16, 16, 16, 16, 4, -8, -2, 16],
			// 3.07748261290986 0.656041415335826 0.818235562525906 14.8665993243064 -7.49893010126728 7.36236718459448 -14.7463141261232 1.63651847874021
			27: [4, 0.5, 1, 16, -8, 8, -16, 2],
			// -20.0 0.235811321808708 0.472170210705952 7.86034356420373 8.44102352136098 -0.396389516144463 0.315536075802636 -6.09857893031771
			28: [-16, 0.5, 0.5, 8, 8, -0.5, 0.5, -8],
			// 3.97491165259932 -0.966712334390927 -0.928451302758772 17.9588102491059 -6.51355963046711 7.22205159151955 -5.10286080093923 -0.555788833631334
			29: [4, -1, -1, 16, -8, 8, -4, -0.5]
		]
		
		for (taskID, weights) in weightsForTaskID {
			testPrecision(onTaskWithID: taskID, usingWeights: weights)
		}
	}
	
	func testPrecision(onTaskWithID taskID: Int, usingWeights weights: [Double]) {
		guard let tasks = try? TaskParser().tasks(withFileAt: environmentPath) else {
			return
		}
		
		let task = tasks[taskID]
		
		let rule = ChalmersLearningRule(coefficients: deltaRuleCoefficients)
		
		var network = SingleLayerSingleOutputNeuralNetwork(weights: weights, activation: sigmoid(λ: 1)) as FeedForwardNeuralNetwork
		
		rule.trainNetwork(&network, task: task, numberOfTimes: 10)
		
		let fitness = 1 - network.testOnTask(task) / Double(task.patterns.count)
		
		print("Task \(taskID): \(fitness)")
	}
	
	func testWeightEncodings() {
		let numberOfBits = 3
		var bits = [Bool](count: numberOfBits, repeatedValue: false)
		
		let offset = -2
		let encoding = signedExponentialEncoding(exponentOffset: offset)
		
		repeat {
			let encodingBits = [1] + bits
			let j = encodedInt(from: bits)
			let value = encoding(bits: encodingBits)
			print("\(makeTestString(bits: bits)) \(j) \(value)")
		} while increment(&bits)
	}
	
	func increment(inout bits: [Bool]) -> Bool {
		for (index, bit) in bits.enumerate().reverse() {
			if bit == false {
				bits[index] = !bit
			}
			else if index == 0 {
				return false
			}
			else {
				bits[index] = false
				var carryIndex: Int? = index - 1
				while let c = carryIndex {
					if bits[c] == false {
						bits[c] = true
						carryIndex = nil
					}
					else if c == 0 {
						return false
					}
					else {
						bits[c] = false
						carryIndex = c - 1
					}
				}
			}
			break
		}
		return true
	}
	
	func testIncrement() {
		var bits: [Bool] = [0, 0]
		
		var success = increment(&bits)
		XCTAssert(success)
		XCTAssertEqual(bits, [0, 1])
		
		success = increment(&bits)
		XCTAssert(success)
		XCTAssertEqual(bits, [1, 0])
		
		success = increment(&bits)
		XCTAssert(success)
		XCTAssertEqual(bits, [1, 1])
		
		success = increment(&bits)
		XCTAssert(!success)
	}

	
}

func makeTestString(bits bits: [Bool]) -> String {
	return bits.map({ $0 ? "1" : "0" }).joinWithSeparator("")
}

extension Bool: IntegerLiteralConvertible {
	
	public init(integerLiteral: Int) {
		if integerLiteral == 0 {
			self.init(false)
		}
		else {
			self.init(true)
		}
	}
	
}
