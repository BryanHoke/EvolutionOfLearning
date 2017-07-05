//
//  ConcurrentDispatcher.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 3/5/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

public struct ConcurrentDispatcher {
	
	public init(queuePriority: dispatch_queue_priority_t) {
		self.queuePriority = queuePriority
	}
	
	public let queuePriority: dispatch_queue_priority_t
	
	public func concurrentlyDispatch(_ blocks: [()->()]) {
		let queue = DispatchQueue.global(priority: queuePriority)
		let group = DispatchGroup()
		
		for block in blocks {
			queue.async(group: group, execute: block)
		}
		
		group.wait(timeout: DispatchTime.distantFuture)
	}
	
}

public func concurrentlyDispatch(_ blocks: [()->()], priority: dispatch_queue_priority_t) {
	let queue = DispatchQueue.global(priority: priority)
	let group = DispatchGroup()
	
	for block in blocks {
		queue.async(group: group, execute: block)
	}
	
	group.wait(timeout: DispatchTime.distantFuture)
}
