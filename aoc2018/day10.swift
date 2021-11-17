//
//  day10.swift
//  aoc2018
//
//  Created by Chris McElroy on 11/3/21.
//

import Foundation

func d10() {
	var (posX, posY, vX, vY) = inputSomeInts(words: [1, 2, 4, 5], ["<", ">", ",", " "]).toTuple()
	
	var i = 1
	while abs(vY[i] - vY[0]) > 4 { i += 1 }
	
	var time = ((posY[i] - posY[0]) / (vY[0] - vY[i])) - 5
	
	for i in 0..<posX.count {
		posX[i] += vX[i] * time
		posY[i] += vY[i] * time
	}
	
	while posY.max()! - posY.min()! > 10 {
		for i in 0..<posX.count {
			posX[i] += vX[i]
			posY[i] += vY[i]
		}
		
		time += 1
	}
	
	var out = (0..<10).map { _ in Array(repeating: " ", count: 62)}
	for i in 0..<posX.count {
		if (0..<10).contains(posY[i] - 162) && (0..<62).contains(posX[i] - 131) {
			out[posY[i] - 162][posX[i] - 131] = "#"
		}
	}
	for o in out {
		print(o.joined())
	}
	print(time)
}

// AHFGRKEE
// 10243
