//
//  day03.swift
//  aoc2018
//
//  Created by Chris McElroy on 11/3/21.
//

import Foundation

func d3() {
	let (startXs, startYs, widths, heights) = inputSomeInts(words: [2, 3, 4, 5], [": ", " ", ",", "x"]).toTuple()
	
	var fabric = (0..<1200).map { _ in Array(repeating: 0, count: 1200) }
	
	for i in 0..<startXs.count {
		let xBounds = startXs[i]..<(startXs[i] + widths[i])
		let yBounds = startYs[i]..<(startYs[i] + heights[i])
		for x in xBounds {
			for y in yBounds {
				fabric[y][x] += 1
			}
		}
	}
	
	print(fabric.reduce(0) { $1.reduce($0) { $0 + ($1 >= 2 ? 1 : 0) } })
	
	var workingID = 0
	for i in 0..<startXs.count {
		let xBounds = startXs[i]..<(startXs[i] + widths[i])
		let yBounds = startYs[i]..<(startYs[i] + heights[i])
		var valid = true
		for x in xBounds {
			for y in yBounds {
				if fabric[y][x] > 1 { valid = false }
			}
		}
		if valid { workingID = i + 1; break }
	}
	
	print(workingID)
}

// 104712
// 840
