//
//  ArrayWrapper.swift
//  EvolutionOfLearning
//
//  Created by Bryan Hoke on 7/13/15.
//  Copyright © 2015 Bryan Hoke. All rights reserved.
//

import Foundation

// MARK: - ArrayWrapper

public protocol ArrayWrapper: RangeReplaceableCollectionType {
	
	// MARK: Associated Types
	
	typealias Element
	
	var wrappedArray: Array<Element> { get set }
	
	var count: Int { get }
	
	var endIndex: Int { get }
	
	var first: Element? { get }
	
	var isEmpty: Bool { get }
	
	// MARK: Instance Methods
	
	mutating func append(newElement: Element)
	
	mutating func extend(newElements: [Element])
	
	func generate() -> IndexingGenerator<Self>
	
	mutating func insert(newElement: Element, atIndex i: Int)
	
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
	
	mutating func append(newElement: Element) {
		wrappedArray.append(newElement)
	}
	
	public mutating func extend(newElements: [Element]) {
		wrappedArray.appendContentsOf(newElements)
	}
	
	public func generate() -> IndexingGenerator<[Element]> {
		return wrappedArray.generate()
	}
	
	public mutating func insert(newElement: Element, atIndex i: Int) {
		wrappedArray.insert(newElement, atIndex: i)
	}
	
	public mutating func removeAll(keepCapacity keepCapacity: Bool) {
		wrappedArray.removeAll(keepCapacity: keepCapacity)
	}
	
	public mutating func removeAtIndex(i: Int) -> Element {
		return wrappedArray.removeAtIndex(i)
	}
	
//	public mutating func removeL
	
}