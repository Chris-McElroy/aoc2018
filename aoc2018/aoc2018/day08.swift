//
//  day08.swift
//  aoc2018
//
//  Created by Chris McElroy on 11/3/21.
//

import Foundation

func day8() {
	struct Node {
		let children: Int
		var foundChildren: Int = 0
		var metadata: Int
		var childValues: [Int] = []
		var value: Int = 0
		
		var finished: Bool { children == foundChildren && metadata == 0 }
		var finishedChildren: Bool { children == foundChildren }
	}
	
	let input = wordLines[0].map { Int($0)! }
	var currentNodes: [Node] = [Node(children: input[0], metadata: input[1])]
	var sum = 0
	var i = 2
	
	while i < input.count {
		if currentNodes.last!.finished {
			currentNodes[currentNodes.count - 2].childValues.append(currentNodes.last!.value)
			currentNodes.removeLast()
		} else if currentNodes.last!.finishedChildren {
			sum += input[i]
			if currentNodes.last!.children == 0 {
				currentNodes[currentNodes.count - 1].value += input[i]
			} else if (1...currentNodes.last!.childValues.count).contains(input[i]) {
				currentNodes[currentNodes.count - 1].value += currentNodes.last!.childValues[input[i] - 1]
			}
			i += 1
			currentNodes[currentNodes.count - 1].metadata -= 1
		} else {
			currentNodes[currentNodes.count - 1].foundChildren += 1
			currentNodes.append(Node(children: input[i], metadata: input[i+1]))
			i += 2
		}
	}
	
	print(sum, currentNodes[0].value)
}
