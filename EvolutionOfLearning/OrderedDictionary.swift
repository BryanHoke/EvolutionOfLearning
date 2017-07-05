//
//  OrderedDictionary.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 2/4/16.
//  Copyright © 2016 Bryan Hoke. All rights reserved.
//

import Foundation

struct OrderedDictionary<Key: Hashable, Value> : ExpressibleByDictionaryLiteral {
	
	fileprivate(set) var dictionary: [Key: Value] = [:]
	
	fileprivate(set) var orderedKeys: [Key] = []
	
	init(dictionaryLiteral elements: (Key, Value)...) {
		for (key, value) in elements {
			orderedKeys.append(key)
			dictionary[key] = value
		}
	}
	
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
	
	func previousValueForKey(_ key: Key) -> Value? {
		guard let index = orderedKeys.index(of: key) else {
			return nil
		}
		let prevIndex = index - 1
		guard prevIndex >= 0 else {
			return nil
		}
		return value(at: prevIndex)
	}
	
	func nextValueForKey(_ key: Key) -> Value? {
		guard let index = orderedKeys.index(of: key) else {
			return nil
		}
		let nextIndex = index + 1
		guard nextIndex < orderedKeys.count else {
			return nil
		}
		return value(at: nextIndex)
	}
	
	mutating func removeAll(keepCapacity: Bool = true) {
		orderedKeys.removeAll(keepingCapacity: keepCapacity)
		dictionary.removeAll(keepingCapacity: keepCapacity)
	}
	
}

extension OrderedDictionary : Collection {
	
	typealias Element = (Key, Value)
	
	typealias Index = Int
	
	typealias Iterator = OrderedDictionaryGenerator<Key, Value>
	
	var count: Int {
		return dictionary.count
	}

	var endIndex: Index {
		return orderedKeys.count
	}
	
	var startIndex: Index {
		guard !orderedKeys.isEmpty else {
			preconditionFailure("An empty collection has no startIndex.")
		}
		return 0
	}
	
	func makeIterator() -> Iterator {
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
	
	subscript(index: Index) -> (Key, Value) {
		let key = orderedKeys[index]
		return (key, dictionary[key]!)
	}
	
}

struct OrderedDictionaryGenerator<Key : Hashable, Value> : IteratorProtocol {
	
	typealias Element = (Key, Value)
	
	fileprivate let orderedDictionary: OrderedDictionary<Key, Value>
	
	fileprivate var currentIndex = 0
	
	init(_ indexedDictionary: OrderedDictionary<Key, Value>) {
		self.orderedDictionary = indexedDictionary
	}
	
	mutating func next() -> Element? {
		guard currentIndex < orderedDictionary.orderedKeys.count else {
			return nil
		}
		
		defer { currentIndex += 1 }
		
		let key = orderedDictionary.orderedKeys[currentIndex]
		
		return (key, orderedDictionary[key]!)
	}
	
}
