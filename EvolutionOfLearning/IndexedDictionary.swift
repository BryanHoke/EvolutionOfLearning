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
	
}

extension IndexedDictionary : CollectionType {
	
	typealias Element = (Key, Value)
	
	typealias Index = DictionaryIndex<Key, Value>
	
	typealias Generator = IndexedDictionaryGenerator<Key, Value>
	
	var count: Int {
		return dictionary.count
	}

	var endIndex: Index {
		guard let lastKey = indexedKeys.last else {
			return dictionary.endIndex
		}
		
		return dictionary.indexForKey(lastKey)!
	}
	
	var startIndex: Index {
		guard let firstKey = indexedKeys.first else {
			return dictionary.startIndex
		}
		
		return dictionary.indexForKey(firstKey)!
	}
	
	func generate() -> Generator {
		return IndexedDictionaryGenerator(self)
	}
	
	subscript(key: Key) -> Value? {
		get {
			return dictionary[key]
		}
		set(newValue) {
			dictionary[key] = newValue
			if !indexedKeys.contains(key) {
				indexedKeys.append(key)
			}
		}
	}
	
	subscript(index: DictionaryIndex<Key, Value>) -> (Key, Value) {
		return dictionary[index]
	}
	
}

struct IndexedDictionaryGenerator<Key : Hashable, Value> : GeneratorType {
	
	typealias Element = (Key, Value)
	
	private let indexedDictionary: IndexedDictionary<Key, Value>
	
	private var currentIndex = 0
	
	init(_ indexedDictionary: IndexedDictionary<Key, Value>) {
		self.indexedDictionary = indexedDictionary
	}
	
	mutating func next() -> Element? {
		guard currentIndex < indexedDictionary.indexedKeys.count else {
			return nil
		}
		
		let key = indexedDictionary.indexedKeys[currentIndex]
		
		return (key, indexedDictionary[key]!)
	}
	
}