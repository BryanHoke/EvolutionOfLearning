//
//  ConcurrentDispatcher.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/5/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct ConcurrentDispatcher {
	
	public init(qos: DispatchQoS.QoSClass) {
		self.qos = qos
	}
	
	public let qos: DispatchQoS.QoSClass
	
	public func concurrentlyDispatch(_ blocks: [()->()]) {
		let queue = DispatchQueue.global(qos: qos)
		let group = DispatchGroup()
		
		for block in blocks {
			queue.async(group: group, execute: block)
		}
		
		let _ = group.wait(timeout: DispatchTime.distantFuture)
	}
	
}

public func concurrentlyDispatch(_ blocks: [()->()], qos: DispatchQoS.QoSClass) {
	let queue = DispatchQueue.global(qos: qos)
	let group = DispatchGroup()
	
	for block in blocks {
		queue.async(group: group, execute: block)
	}
	
	let _ = group.wait(timeout: DispatchTime.distantFuture)
}
