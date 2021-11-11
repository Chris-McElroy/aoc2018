//
//  day12.swift
//  aoc2018
//
//  Created by Chris McElroy on 11/3/21.
//

import Foundation

func d12() {
	let size = 150 // may need to be expanded for other inputs
	
	var lastActive = inputWords()[0][2]
	var state = String(Array(repeating: ".", count: size + 2)) + lastActive + String(Array(repeating: ".", count: size + 2))
	let conversions: [String: String] = Dictionary(from: Array(inputWords().dropFirst(2)), key: 0, value: 2)
	
	func sumState() -> Int {
		var sum = 0
		for i in 0..<state.count {
			if state[i] == "#" {
				sum += i - size - 2
			}
		}
		return sum
	}
	
	for generation in 1...size {
		var nextState = ".."
		for i in 2..<(state.count - 2) {
			var old = ""
			for j in (i-2)...(i+2) {
				if state[j] == "#" {
					old += "#"
				} else {
					old += "."
				}
			}
			nextState += conversions[old]!
		}
		
		state = nextState + ".."
		
		if generation == 20 { print(sumState()) }
		
		if state[state.firstIndex(of: "#")!...state.lastIndex(of: "#")!] == lastActive {
			print(sumState() + state.repeats(of: "#")*(50000000000 - generation))
			break
		}
		
		lastActive = state[state.firstIndex(of: "#")!...state.lastIndex(of: "#")!]
	}
}

// 3915
// 4900000001793
