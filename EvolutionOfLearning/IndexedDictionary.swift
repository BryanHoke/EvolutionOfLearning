//
//  IndexedDictionary.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 2/4/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

struct OrderedDictionary<Key: Hashable, Value> {
	
	private var dictionary: [Key: Value] = [:]
	
	private var orderedKeys: [Key] = []
	
	var lastKey: Key? {
		return orderedKeys.last
	}
	
	var lastValue: Value? {
		guard let lastKey = self.lastKey else {
			return nil
		}
		return dictionary[lastKey]
	}
	
	func value(at index: Int) -> Value? {
		let key = orderedKeys[index]
		return dictionary[key]
	}
	
	func previousValueForKey(key: Key) -> Value? {
		guard let index = orderedKeys.indexOf(key) else {
			return nil
		}
		let prevIndex = index - 1
		guard prevIndex >= 0 else {
			return nil
		}
		return value(at: prevIndex)
	}
	
	func nextValueForKey(key: Key) -> Value? {
		guard let index = orderedKeys.indexOf(key) else {
			return nil
		}
		let nextIndex = index + 1
		guard nextIndex < orderedKeys.count else {
			return nil
		}
		return value(at: nextIndex)
	}
	
	mutating func removeAll(keepCapacity keepCapacity: Bool = true) {
		orderedKeys.removeAll(keepCapacity: keepCapacity)
		dictionary.removeAll(keepCapacity: keepCapacity)
	}
	
}

extension OrderedDictionary : CollectionType {
	
	typealias Element = (Key, Value)
	
	typealias Index = DictionaryIndex<Key, Value>
	
	typealias Generator = OrderedDictionaryGenerator<Key, Value>
	
	var count: Int {
		return dictionary.count
	}

	var endIndex: Index {
		guard let lastKey = orderedKeys.last else {
			return dictionary.endIndex
		}
		
		return dictionary.indexForKey(lastKey)!
	}
	
	var startIndex: Index {
		guard let firstKey = orderedKeys.first else {
			return dictionary.startIndex
		}
		
		return dictionary.indexForKey(firstKey)!
	}
	
	func generate() -> Generator {
		return OrderedDictionaryGenerator(self)
	}
	
	subscript(key: Key) -> Value? {
		get {
			return dictionary[key]
		}
		set(newValue) {
			dictionary[key] = newValue
			if !orderedKeys.contains(key) {
				orderedKeys.append(key)
			}
		}
	}
	
	subscript(index: DictionaryIndex<Key, Value>) -> (Key, Value) {
		return dictionary[index]
	}
	
}

struct OrderedDictionaryGenerator<Key : Hashable, Value> : GeneratorType {
	
	typealias Element = (Key, Value)
	
	private let orderedDictionary: OrderedDictionary<Key, Value>
	
	private var currentIndex = 0
	
	init(_ indexedDictionary: OrderedDictionary<Key, Value>) {
		self.orderedDictionary = indexedDictionary
	}
	
	mutating func next() -> Element? {
		guard currentIndex < orderedDictionary.orderedKeys.count else {
			return nil
		}
		
		let key = orderedDictionary.orderedKeys[currentIndex]
		
		return (key, orderedDictionary[key]!)
	}
	
}