//
//  day11.swift
//  aoc2018
//
//  Created by Chris McElroy on 11/3/21.
//

import Foundation

func d11() {
	let serial = inputInts()[0]
	
	var fuels = make2DArray(repeating: 0, count1: 301, count2: 301)
	
	var best = Int.min
	var bestX = 0
	var bestY = 0
	var bestSize = 0
	
	for x in 1...300 {
		let rackID = x + 10
		for y in 1...300 {
			fuels[y][x] = (((rackID * (rackID * y + serial)) / 100) % 10) - 5
			
			if fuels[y][x] > best {
				best = fuels[y][x]
				bestX = x
				bestY = y
				bestSize = 1
			}
		}
	}
	
	var sums = fuels
	var oldSums = make2DArray(repeating: 0, count1: 301, count2: 301)
	
	for size in 2...300 {
		var newSums = sums
		for x in 1...(301 - size) {
			for y in 1...(301 - size) {
				newSums[y][x] += sums[y + 1][x + 1] + fuels[y + size - 1][x] + fuels[y][x + size - 1] - oldSums[y + 1][x + 1]
				
				if newSums[y][x] > best {
					best = newSums[y][x]
					bestX = x
					bestY = y
					bestSize = size
				}
			}
		}
		
		oldSums = sums
		sums = newSums
	}
	
	print("\(bestX),\(bestY),\(bestSize)")
}

// 235,35
// 142,265,7
