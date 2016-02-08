//
//  IndexedDictionary.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 2/4/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

struct IndexedDictionary<Key: Hashable, Value> {
	
	private var dictionary: [Key: Value] = [:]
	
	private var indexedKeys: [Key] = []
	
	var lastKey: Key? {
		return indexedKeys.last
	}
	
	var lastValue: Value? {
		guard let lastKey = self.lastKey else {
			return nil
		}
		return dictionary[lastKey]
	}
	
	func valueAt(index: Int) -> Value? {
		let key = indexedKeys[index]
		return dictionary[key]
	}
	
	func previousValueForKey(key: Key) -> Value? {
		guard let index = indexedKeys.indexOf(key) else {
			return nil
		}
		let prevIndex = index - 1
		guard prevIndex >= 0 else {
			return nil
		}
		return valueAt(prevIndex)
	}
	
	func nextValueForKey(key: Key) -> Value? {
		guard let index = indexedKeys.indexOf(key) else {
			return nil
		}
		let nextIndex = index + 1
		guard nextIndex < indexedKeys.count else {
			return nil
		}
		return valueAt(nextIndex)
	}
	
	mutating func removeAll(keepCapacity keepCapacity: Bool = true) {
		indexedKeys.removeAll(keepCapacity: keepCapacity)
		dictionary.removeAll(keepCapacity: keepCapacity)
	}
	
	subscript(key: Key) -> Value? {
		return dictionary[key]
	}
	
}