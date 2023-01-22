//
//  main.swift
//  Advent of Code
//
//  Created by DanielJohns on 2022-11-08.
//

import Foundation
import Algorithms
import AdventOfCodeKit

let arguments = CommandLine.arguments.dropFirst()
var day, year, cookie: String?

for (param, value) in arguments.adjacentPairs() {
    switch param {
    case "-d":
        day = value
    case "-y":
        year = value
    case "-c":
        cookie = value
    default:
        break
    }
}

guard let day else {
    fatalError("Missing day parameter")
}

await run(day, year, cookie)
