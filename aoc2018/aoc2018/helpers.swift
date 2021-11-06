//
//  helpers.swift
//  aoc2018
//
//  Created by Chris McElroy on 11/2/21.
//

import Foundation
import Accelerate
import CryptoKit

// input functions //

public func inputLines(_ num: Int) -> [String] {
	do {
		let home = FileManager.default.homeDirectoryForCurrentUser
		let name = "input" + (num < 10 ? "0" : "") + "\(num)"
		let filePath = projectFolder + "/aoc2018/" + name
		let file = URL(fileURLWithPath: filePath, relativeTo: home)
		return try String(contentsOf: file).fullSplit(separator: "\n")
	} catch {
		print("Error: bad file name")
		return []
	}
}

public func inputInts(_ num: Int) -> [Int] {
	let input = inputLines(num)
	return input.map { Int($0) ?? 0 }
}

public func inputWords(_ num: Int) -> [[String]] {
	let input = inputLines(num)
	return input.map { $0.fullSplit(separator: " ") }
}

// shortcuts //

public extension Collection where Indices.Iterator.Element == Index {
	subscript(w i: Int?) -> Iterator.Element? {
		guard let j = i else { return nil }
		return self[index(startIndex, offsetBy: j % count)]
	}
	
	func first(_ k: Int) -> Self.SubSequence {
		return self.dropLast(count-k)
	}
	
	func last(_ k: Int) -> SubSequence {
		return self.dropFirst(count-k)
	}
	
	func slice(start: Int, len: Int) -> SubSequence {
		return self.first(start+len).dropFirst(start)
	}
	
	subscript(_ s: Int, _ e: Int) -> SubSequence {
		return self.first(e).dropFirst(s)
	}
	
	func each(_ k: Int) -> Array<SubSequence> {
		var array: Array<SubSequence> = []
		var i = 0
		while i < count {
			array.append(slice(start: i, len: Swift.min(k, count-i)))
			i += k
		}
		return array
	}
}

public extension Collection where Element: Equatable {
	func repeats(of e: Element) -> Int {
		return self.filter({ $0 == e }).count
	}
}

public extension Collection where Element: Hashable {
	func occurs(min: Int) -> Array<Element> {
		var counts: Dictionary<Element, Int> = [:]
		self.forEach { counts[$0, default: 0] += 1 }
		return Array(counts.filter { $0.value >= min }.keys)
	}
}

public extension Collection where Element: Numeric {
	func product() -> Element {
		return self.reduce(1) { x,y in x*y }
	}
	
	func sum() -> Element {
		return self.reduce(0) { x,y in x+y }
	}
}

public extension Collection where Element: AdditiveArithmetic {
	func twoSumTo(_ s: Element) -> [Element]? {
		guard let x = first(where: { contains(s-$0) }) else { return nil }
		return [x, s-x]
	}
	
	func nSumTo(_ s: Element, n: Int) -> [Element]? {
		if n == 2 { return twoSumTo(s) }
		for e in self {
			if var arr = nSumTo(s-e, n: n-1) {
				arr.append(e)
				return arr
			}
		}
		return nil
	}
}

public extension Array {
	subscript(w i: Int) -> Iterator.Element? {
		return self[index(startIndex, offsetBy: i % count)]
	}
	
	subscript(s i: Int) -> Iterator.Element? {
		if i < 0 || i >= count { return nil }
		return self[i]
	}
	
	func first(_ k: Int) -> Self.SubSequence {
		return self.dropLast(count-k)
	}
	
	func last(_ k: Int) -> Self.SubSequence {
		return self.dropFirst(count-k)
	}
	
	func slice(from start: Int, to end: Int, by k: Int) -> Self {
		let newSlice = slice(from: start, to: end)
		return newSlice.enumerated().compactMap { i,e in i.isMultiple(of: k) ? e : nil }
	}
	
	func slice(from start: Int, to end: Int) -> Self.SubSequence {
		return self.first(end).dropFirst(start)
	}
	
	func slice(from start: Int, through end: Int, by k: Int) -> Self {
		return slice(from: start, to: end+1, by: k)
	}
	
	func slice(from start: Int, through end: Int) -> Self.SubSequence {
		return self.slice(from: start, to: end+1)
	}
	
	subscript(_ s: Int, _ e: Int) -> Self.SubSequence {
		return self.first(e).dropFirst(s)
	}
	
	mutating func pushOn(_ new: Element) {
		self = self.dropFirst() + [new]
	}
}

public extension Array where Element: Equatable {
	func fullSplit(separator: Element) -> Array<Self> {
		return self.split(whereSeparator: { $0 == separator}).map { Self($0) }
	}
}

public extension String {
	func fullSplit(separator: Character) -> [String] {
		let s = self.split(separator: separator, maxSplits: .max, omittingEmptySubsequences: false).map { String($0) }
		if s.last == "" {
			return s.dropLast(1)
		} else {
			return s
		}
	}
	
	func occurs(min: Int) -> String {
		var counts: Dictionary<Character, Int> = [:]
		self.forEach { counts[$0, default: 0] += 1 }
		return String(counts.filter { $0.value >= min }.keys)
	}
	
	subscript(w i: Int) -> Character? {
		return self[index(startIndex, offsetBy: i % count)]
	}
	
	subscript(s i: Int) -> Character? {
		if i < 0 || i >= count { return nil }
		return self[i]
	}
	
	func slice(from start: Int, to end: Int, by k: Int) -> Self {
		let newSlice = slice(from: start, to: end)
		return String(newSlice.enumerated().compactMap { i,e in i.isMultiple(of: k) ? e : nil })
	}
	
	func slice(from start: Int, through end: Int, by k: Int) -> Self {
		return slice(from: start, to: end+1, by: k)
	}
	
	func firstIndex(of element: Character) -> Int? {
		firstIndex(of: element)?.utf16Offset(in: self)
	}
}

public extension StringProtocol {
	subscript(offset: Int) -> Character {
		self[index(startIndex, offsetBy: offset)]
	}
	
	subscript(_ s: Int, _ e: Int) -> SubSequence {
		return self.first(e).dropFirst(s)
	}
	
	func first(_ k: Int) -> Self.SubSequence {
		return self.dropLast(count-k)
	}
	
	func last(_ k: Int) -> Self.SubSequence {
		return self.dropFirst(count-k)
	}
	
	func slice(from start: Int, through end: Int) -> Self.SubSequence {
		return self.slice(from: start, to: end+1)
	}
	
	func slice(from start: Int, to end: Int) -> Self.SubSequence {
		return self.first(start+end).dropFirst(start)
	}
	
	func isin(_ string: Self?) -> Bool {
		return string?.contains(self) == true
	}
	
	func repititions(n: Int) -> [Character] {
		var last: Character = " "
		var count = 0
		var output: [Character] = []
		
		for c in self {
			if last == c {
				count += 1
				if count == n {
					output.append(c)
				}
			} else {
				last = c
				count = 1
			}
		}
		
		return output
	}
}

public extension Character {
	static func +(lhs: Character, rhs: Int) -> Character {
		if lhs.isLetter {
			let aVal: UInt32 = lhs.isUppercase ? 65 : 97
			if let value = lhs.unicodeScalars.first?.value {
				if let scalar = UnicodeScalar((value - aVal + UInt32(rhs)) % 26 + aVal) {
					return Character(scalar)
				}
			}
		}
		return lhs
	}
}

extension RangeReplaceableCollection {
	// from https://stackoverflow.com/questions/25162500/apple-swift-generate-combinations-with-repetition
	// I should use rangereplacablecollection for everything i think
	func combinations(of n: Int) -> [SubSequence] {
		guard n > 0 else { return [.init()] }
		guard let first = first else { return [] }
		return combinations(of: n - 1).map { CollectionOfOne(first) + $0 } + dropFirst().combinations(of: n)
	}
	func uniqueCombinations(of n: Int) -> [SubSequence] {
		guard n > 0 else { return [.init()] }
		guard let first = first else { return [] }
		return dropFirst().uniqueCombinations(of: n - 1).map { CollectionOfOne(first) + $0 } + dropFirst().uniqueCombinations(of: n)
	}
	
	mutating func insert(_ newElement: Self.Element, _ i: Int) {
		self.insert(newElement, at: index(self.startIndex, offsetBy: i))
	}
}

// permutations from https://stackoverflow.com/questions/34968470/calculate-all-permutations-of-a-string-in-swift
func permutations<T>(len n: Int, _ a: inout [T], output: inout [[T]]) {
	if n == 1 { output.append(a); return }
	for i in stride(from: 0, to: n, by: 1) {
		permutations(len: n-1, &a, output: &output)
		a.swapAt(n-1, (n%2 == 1) ? 0 : i)
	}
}

public extension Comparable {
	func isin(_ collection: Array<Self>?) -> Bool {
		return collection?.contains(self) == true
	}
	
	mutating func swap(_ x: Self, _ y: Self) {
		self = (self == x) ? y : x
	}
}

public extension Equatable {
	func isin(_ one: Self, _ two: Self, _ three: Self) -> Bool {
		return self == one || self == two || self == three
	}
}

public extension Hashable {
	func isin(_ collection: Set<Self>?) -> Bool {
		return collection?.contains(self) == true
	}
}

public extension Character {
	func isin(_ string: String?) -> Bool {
		return string?.contains(self) == true
	}
}

public extension Numeric where Self: Comparable {
	func isin(_ range: ClosedRange<Self>?) -> Bool {
		return range?.contains(self) == true
	}
	
	func isin(_ range: Range<Self>?) -> Bool {
		return range?.contains(self) == true
	}
}

infix operator ** : MultiplicationPrecedence
public extension Numeric {
	func sqrd() -> Self {
		self*self
	}
	
	static func ** (lhs: Self, rhs: Int) -> Self {
		(0..<rhs).reduce(1) { x,y in x*lhs }
	}
}

public extension Bool {
	var int: Int { self ? 1 : 0 }
}

func timed(_ run: () -> Void) {
	let start = Date().timeIntervalSinceReferenceDate
	run()
	let end = Date().timeIntervalSinceReferenceDate
	print("in:", end-start)
}

public extension BinaryFloatingPoint {
	var isWhole: Bool { self.truncatingRemainder(dividingBy: 1) == 0 }
	var isEven: Bool { Int(self) % 2 == 0 }
	var isOdd: Bool { Int(self) % 2 == 1 }
	var int: Int? { isWhole ? Int(self) : nil }
}

public extension BinaryInteger {
	var isEven: Bool { self % 2 == 0 }
	var isOdd: Bool { self % 2 == 1 }
}

struct C2: Equatable, Hashable, AdditiveArithmetic {
	var x: Int
	var y: Int
	
	init(_ x: Int, _ y: Int) {
		self.x = x
		self.y = y
	}
	
	static let zeroAdjacents = [(-1,0),(0,-1),(0,1),(1,0)]
	static let zeroNeighbors = [(-1,-1),(-1,0),(-1,1),(0,-1),(0,1),(1,-1),(1,0),(1,1)]
	var adjacents: [C2] { C2.zeroAdjacents.map({ C2(x + $0.0, y + $0.1) }) }
	var neighbors: [C2] { C2.zeroNeighbors.map({ C2(x + $0.0, y + $0.1) }) }
	var adjacentsWithSelf: [C2] { C2.zeroAdjacents.map({ C2(x + $0.0, y + $0.1) }) + [self] }
	var neighborsWithSelf: [C2] { C2.zeroNeighbors.map({ C2(x + $0.0, y + $0.1) }) + [self] }
	
	static var zero: C2 = C2(0, 0)
	
	mutating func rotateLeft() {
		let tempX = x
		x = -y
		y = tempX
	}
	
	mutating func rotateRight() {
		let tempX = x
		x = y
		y = -tempX
	}
	
	mutating func rotate(left: Bool) {
		left ? rotateLeft() : rotateRight()
	}
	
	func manhattanDistance() -> Int {
		abs(x) + abs(y)
	}
	
	func vectorLength() -> Double {
		sqrt(Double(x*x + y*y))
	}
	
	static func + (lhs: C2, rhs: C2) -> C2 {
		C2(lhs.x + rhs.x, lhs.y + rhs.y)
	}
	
	static func - (lhs: C2, rhs: C2) -> C2 {
		C2(lhs.x - rhs.x, lhs.y - rhs.y)
	}
}

struct C3: Equatable, Hashable, AdditiveArithmetic {
	var x: Int
	var y: Int
	var z: Int
	
	init(_ x: Int, _ y: Int, _ z: Int) {
		self.x = x
		self.y = y
		self.z = z
	}
	
	static let zeroAdjacents = [(-1,0,0),(0,-1,0),(0,0,-1),(0,0,1),(0,1,0),(1,0,0)]
	static let zeroNeighbors = [(-1,-1,-1),(-1,-1,0),(-1,-1,1),(-1,0,-1),(-1,0,0),(-1,0,1),(-1,1,-1),(-1,1,0),(-1,1,1),
								(0,-1,-1),(0,-1,0),(0,-1,1),(0,0,-1),(0,0,1),(0,1,-1),(0,1,0),(0,1,1),
								(1,-1,-1),(1,-1,0),(1,-1,1),(1,0,-1),(1,0,0),(1,0,1),(1,1,-1),(1,1,0),(1,1,1)]
	var adjacents: [C3] { C3.zeroAdjacents.map({ C3(x + $0.0, y + $0.1, z + $0.2) }) }
	var neighbors: [C3] { C3.zeroNeighbors.map({ C3(x + $0.0, y + $0.1, z + $0.2) }) }
	var adjacentsWithSelf: [C3] { C3.zeroAdjacents.map({ C3(x + $0.0, y + $0.1, z + $0.2) }) + [self] }
	var neighborsWithSelf: [C3] { C3.zeroNeighbors.map({ C3(x + $0.0, y + $0.1, z + $0.2) }) + [self] }
	
	static var zero: C3 = C3(0, 0, 0)
	
	func manhattanDistance() -> Int {
		abs(x) + abs(y) + abs(z)
	}
	
	func vectorLength() -> Double {
		sqrt(Double(x*x + y*y + z*z))
	}
	
	static func + (lhs: C3, rhs: C3) -> C3 {
		C3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
	}
	
	static func - (lhs: C3, rhs: C3) -> C3 {
		C3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
	}
}

func MD5(of string: String) -> String {
	String(Insecure.MD5.hash(data: (string).data(using: .utf8)!).description.dropFirst(12))
}

// adapted from https://www.raywenderlich.com/947-swift-algorithm-club-swift-linked-list-data-structure
class LinkedNode<Element> {
	var value: Element
	weak var prev: LinkedNode?
	var next: LinkedNode?
	
	init (_ value: Element) {
		self.value = value
	}
}

class LinkedList<Element> {
	private var head: LinkedNode<Element>?
	private var tail: LinkedNode<Element>?

	public var isEmpty: Bool {
	return head == nil
	}

	public var first: Element? {
		return head?.value
	}

	public var last: Element? {
		return tail?.value
	}
	
	public func append(_ newElement: Element) {
		let newNode = LinkedNode(newElement)
		if let tailNode = tail {
			newNode.prev = tailNode
			tailNode.next = newNode
		} else {
			head = newNode
		}
		tail = newNode
	}
}

class LinkedCycle<Element>: CustomStringConvertible {
	private var currentNode: LinkedNode<Element>?
	
	var current: Element? { currentNode?.value }
	
	func insertNext(_ newElement: Element) {
		let newNode = LinkedNode(newElement)
		if let currentNode = currentNode {
			let next = currentNode.next
			currentNode.next = newNode
			newNode.prev = currentNode
			newNode.next = next
			next?.prev = newNode
		} else {
			newNode.prev = newNode
			newNode.next = newNode
			currentNode = newNode
		}
	}
	
	func insertPrev(_ newElement: Element) {
		let newNode = LinkedNode(newElement)
		if let currentNode = currentNode {
			let prev = currentNode.prev
			currentNode.prev = newNode
			newNode.prev = prev
			newNode.next = currentNode
			prev?.next = newNode
		} else {
			newNode.prev = newNode
			newNode.next = newNode
			currentNode = newNode
		}
	}
	
	func shiftCurrent(by n: Int) {
		if currentNode == nil { return }
		if n > 0 {
			currentNode = currentNode!.next
			shiftCurrent(by: n - 1)
		} else if n < 0 {
			currentNode = currentNode!.prev
//			print(self)
			shiftCurrent(by: n + 1)
		}
	}
	
	@discardableResult func removeAndGoToNext() -> Element? {
		let value = currentNode?.value
		if currentNode?.next === currentNode {
			currentNode = nil
			return nil
		} else {
			let prev = currentNode?.prev
			currentNode = currentNode?.next
			currentNode?.prev = prev
			prev?.next = currentNode
		}
		return value
	}
	
	public var description: String {
		var text = "["
		var node = currentNode

		repeat {
			text += "\(node!.value)"
			node = node!.next
			if node !== currentNode { text += ", " }
		} while node !== currentNode
		return text + "]"
	}
}

func bfs<T>(startingWith start: Set<T>, searchFor solution: ((T, Int, Set<T>) -> Bool) = { _,_,_ in false }, expandUsing search: (T) -> [T], continueWhile shouldContinue: (Int, Set<T>) -> Bool) {
	var steps = 0
	var found: Set<T> = []
	var current: Set<T> = start
	
	w: while shouldContinue(steps, found) && !current.isEmpty {
		steps += 1
		var next: Set<T> = []
		
		for a in current {
			for b in search(a) {
				if solution(b, steps, found) { break w }
				
				if found.insert(b).inserted {
					next.insert(b)
				}
			}
		}
		
		current = next
	}
}

// from https://stackoverflow.com/questions/28349864/algorithm-for-lcm-of-doubles-in-swift
// GCD of two numbers:
func gcd(_ a: Int, _ b: Int) -> Int {
	var (a, b) = (a, b)
	while b != 0 {
		(a, b) = (b, a % b)
	}
	return abs(a)
}

// GCD of a vector of numbers:
func gcd(_ vector: [Int]) -> Int {
	return vector.reduce(0, gcd)
}

// LCM of two numbers:
func lcm(_ a: Int, _ b: Int) -> Int {
	return (a / gcd(a, b)) * b
}

// LCM of a vector of numbers:
func lcm(_ vector: [Int]) -> Int {
	return vector.reduce(1, lcm)
}

extension Int {
	var isPrime: Bool {
		// from https://stackoverflow.com/questions/31105664/check-if-a-number-is-prime
		guard self >= 2     else { return false }
		guard self != 2     else { return true  }
		guard self % 2 != 0 else { return false }
		return !stride(from: 3, through: Int(sqrt(Double(self))), by: 2).contains { self % $0 == 0 }
	}
}

enum Operation {
	case set, inc, dec, add, sub, mod, mult, div
	case jump, jnz, jez, jgz, jlz
}

func intOrReg(val: String, reg: [String: Int]) -> Int {
	if let n = Int(val) { return n }
	return reg[val] ?? 0
}

func compute(with language: [String: Operation], program: [[String]] = wordLines, reg: inout [String: Int], line i: inout Int) {
	
	let line = program[i]
	let v1 = intOrReg(val: line[1], reg: reg)
	let v2 = line.count < 3 ? 0 : intOrReg(val: line[2], reg: reg)
	
	switch language[line[0]] {
	case .set:
		reg[line[1]] = v2
	case .inc:
		reg[line[1], default: 0] += 1
	case .dec:
		reg[line[1], default: 0] -= 1
	case .add:
		reg[line[1], default: 0] += v2
	case .sub:
		reg[line[1], default: 0] -= v2
	case .mod:
		reg[line[1], default: 0] %= v2
	case .mult:
		reg[line[1], default: 0] *= v2
	case .div:
		reg[line[1], default: 0] /= v2
		
	case .jump:
		i += v1 - 1
	case .jnz:
		if v1 != 0 { i += v2 - 1 }
	case .jez:
		if v1 == 0 { i += v2 - 1 }
	case .jgz:
		if v1 > 0 { i += v2 - 1 }
	case .jlz:
		if v1 < 0 { i += v2 - 1 }
		
	case .none:
		break
	}
	
	i += 1
	
}
