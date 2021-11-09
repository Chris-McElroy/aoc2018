//
//  day07.swift
//  aoc2018
//
//  Created by Chris McElroy on 11/3/21.
//

import Foundation

func d7() {
	let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	let steps = inputWords()
	let total = Int(steps.map { $0[7].first!.asciiValue! - 65 }.max()!) + 1
	var reqs: [[Int]] = Array(repeating: [], count: total)
	var order: [Int] = []
	
	for line in steps {
		let req = Int(line[1].first!.asciiValue! - 65)
		let step = Int(line[7].first!.asciiValue! - 65)
		reqs[step].append(req)
	}
	
	while order.count < total {
		var ready: [Int] = []
		for step in 0..<total where !order.contains(step) {
			if !reqs[step].contains(where: { !order.contains($0) }) {
				ready.append(step)
			}
		}
		order.append(ready.min()!)
	}
	
	var time = 0
	var started: [Int] = []
	var active: [(id: Int, rem: Int)] = []
	var finished: [Int] = []
	
	while finished.count < total {
		var ready: [Int] = []
		for step in 0..<total where !started.contains(step) {
			if !reqs[step].contains(where: { !finished.contains($0) }) {
				ready.append(step)
			}
		}
		
		ready.sort()
		while !ready.isEmpty && active.count < 5 {
			let newStep = ready.removeFirst()
			started.append(newStep)
			active.append((id: newStep, rem: newStep + 60))
		}
		
		time += 1
		
		var newActive: [(id: Int, rem: Int)] = []
		for (id, rem) in active {
			if rem == 0 {
				finished.append(id)
			} else {
				newActive.append((id: id, rem: rem - 1))
			}
		}
		active = newActive
	}
	
	print(order.map({ String(alphabet[$0]) }).joined())
	print(time)
}
// CFGHAEMNBPRDISVWQUZJYTKLOX
// 828
