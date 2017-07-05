//
//  ArrayWrapper.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/13/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

// MARK: - ArrayWrapper

public protocol ArrayWrapper: RangeReplaceableCollection {
	
	// MARK: Associated Types
	
	associatedtype Element
	
	var wrappedArray: Array<Element> { get set }
	
	var count: Int { get }
	
	var endIndex: Int { get }
	
	var first: Element? { get }
	
	var isEmpty: Bool { get }
	
	// MARK: Instance Methods
	
	mutating func append(_ newElement: Element)
	
	mutating func extend(_ newElements: [Element])
	
	func generate() -> IndexingIterator<Self>
	
	mutating func insert(_ newElement: Element, atIndex i: Int)
	
	mutating func removeLast() -> Element
	
	// MARK: Subscripts
	
	subscript(index: Int) -> Element { get set }
}

extension ArrayWrapper {
	
	var count: Int {
		return wrappedArray.count
	}
	
	var endIndex: Int {
		return wrappedArray.endIndex
	}
	
	var first: Element? {
		return wrappedArray.first
	}
	
	var isEmpty: Bool {
		return wrappedArray.isEmpty
	}
	
	subscript(index: Int) -> Element {
		get {
			return wrappedArray[index]
		}
		set {
			wrappedArray[index] = newValue
		}
	}
	
	mutating func append(_ newElement: Element) {
		wrappedArray.append(newElement)
	}
	
	public mutating func extend(_ newElements: [Element]) {
		wrappedArray.append(contentsOf: newElements)
	}
	
	public func generate() -> IndexingIterator<[Element]> {
		return wrappedArray.makeIterator()
	}
	
	public mutating func insert(_ newElement: Element, atIndex i: Int) {
		wrappedArray.insert(newElement, at: i)
	}
	
	public mutating func removeAll(keepCapacity: Bool) {
		wrappedArray.removeAll(keepingCapacity: keepCapacity)
	}
	
	public mutating func removeAtIndex(_ i: Int) -> Element {
		return wrappedArray.remove(at: i)
	}
	
//	public mutating func removeL
	
}
