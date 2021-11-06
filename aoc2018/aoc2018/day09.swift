//
//  day09.swift
//  aoc2018
//
//  Created by Chris McElroy on 11/3/21.
//

import Foundation

func day9() {
	let players = 410
	let lastMarble = 7205900
	
	let marbles: LinkedCycle<Int> = LinkedCycle<Int>()
	var scores: [Int: Int] = [:]
	var nextMarble = 1
	var currentPlayer = 0
	
	marbles.insertNext(0)
	
	while nextMarble <= lastMarble {
		if nextMarble % 23 == 0 {
			scores[currentPlayer, default: 0] += nextMarble
			marbles.shiftCurrent(by: -7)
			scores[currentPlayer, default: 0] += marbles.removeAndGoToNext()!
		} else {
			marbles.shiftCurrent(by: 1)
			marbles.insertNext(nextMarble)
			marbles.shiftCurrent(by: 1)
		}
		
		nextMarble += 1
		currentPlayer += 1
		currentPlayer %= players
	}
	
	print(scores.values.max()!)
}

// 429287
// 3624387659
