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
	
	public func concurrentlyDispatch(blocks: [dispatch_block_t]) {
		let queue = dispatch_get_global_queue(queuePriority, 0)
		let group = dispatch_group_create()
		
		for block in blocks {
			dispatch_group_async(group, queue, block)
		}
		
		dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
	}
	
}

public func concurrentlyDispatch(blocks: [dispatch_block_t], priority: dispatch_queue_priority_t) {
	let queue = dispatch_get_global_queue(priority, 0)
	let group = dispatch_group_create()
	
	for block in blocks {
		dispatch_group_async(group, queue, block)
	}
	
	dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
}
