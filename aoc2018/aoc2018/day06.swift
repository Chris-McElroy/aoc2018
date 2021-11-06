//
//  day06.swift
//  aoc2018
//
//  Created by Chris McElroy on 11/2/21.
//

import Foundation

func day6() {
	let coords: [C2] = wordLines.map { C2(Int($0[0].dropLast())!, Int($0[1])!) }
	var numClosest = Array(repeating: 0, count: coords.count)
	var inRegion = 0
	let xBounds = (coords.min(by: { $0.x < $1.x })!.x)...(coords.max(by: { $0.x < $1.x })!.x)
	let yBounds = (coords.min(by: { $0.y < $1.y })!.y)...(coords.max(by: { $0.y < $1.y })!.y)
	
	print(xBounds, yBounds)
	
	for x in xBounds {
		for y in yBounds {
			let pos = C2(x, y)
			let distances = coords.map { ($0 - pos).manhattanDistance() }
			if distances.sum() < 10000 {
				inRegion += 1
			}
			let minDist = distances.min()!
			let nearest = distances.firstIndex(of: minDist)!
			if numClosest[nearest] >= 0 {
				if x == xBounds.lowerBound || x == xBounds.upperBound || y == yBounds.lowerBound || y == yBounds.upperBound {
					numClosest[nearest] = -1
				} else if nearest == distances.lastIndex(of: minDist) {
					numClosest[nearest] += 1
				}
			}
		}
	}
	
	print(numClosest.max()!)
	print(inRegion)
}
