//
//  main.swift
//  aoc2018
//
//  Created by Chris McElroy on 11/2/21.
//

import Foundation

// change to the project's file path before running
let projectFolder = "main/code/aoc2018/aoc2018"

let day = 9

let input = inputLines(day)
let wordLines = inputWords(day)
let intLines = inputInts(day)

switch day {
case 6: day6()
case 7: timed(day7)
case 8: timed(day8)
case 9: timed(day9)
default: break
}
