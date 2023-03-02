//
//  entry.swift
//  AdventOfCodeKit
//
//  Created by DanielJohns on 2022-12-03.
//

import Foundation
import AppKit

let inputBaseUrl = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent("Documents", isDirectory: true)
    .appendingPathComponent("AdventOfCode", isDirectory: true)

func inputUrl(for day: String) -> URL {
    return inputBaseUrl
        .appendingPathComponent("Day\(day)", isDirectory: true)
        .appendingPathComponent("input", isDirectory: false)
}

func downloadInput(for day: String, year: String, cookie: String) async -> String? {
    guard let url = URL(string: "https://www.adventofcode.com/\(year)/day/\(day)/input") else {
        return nil
    }
    
    var request = URLRequest(url: url)
    request.addValue(cookie, forHTTPHeaderField: "Cookie")
    guard let response = try? await URLSession.shared.data(for: request) else {
        return nil
    }
    guard let httpResponse = response.1 as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        return nil
    }
    let string = String(data: response.0, encoding: .utf8)
    
    try? string?.write(to: inputUrl(for: day), atomically: true, encoding: .utf8)
    return string
}

public func run(_ day: String, _ year: String?, _ cookie: String?) async {
    let url = inputUrl(for: day)
    
    let input: String
    if let fileInput = try? String(contentsOf: url), !fileInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        input = fileInput
    } else if let year, let cookie, let netInput = await downloadInput(for: day, year: year, cookie: cookie) {
        input = netInput
    } else {
        debugPrint("Unable to find input for \(day). Check Day\(day)/input or verify your cookie is still good.")
        return
    }
    
    guard let dayClass = Bundle(for: BundleFinder.self).classNamed("AdventOfCodeKit.Day\(day)") as? Day.Type else {
        debugPrint("Unable to create Day class for \(day)")
        return
    }
    
    print("Running day \(day)")
    let result = dayClass.init().run(input: input.trimmingCharacters(in: .newlines))
    print(result)
    NSPasteboard.general.clearContents()
    NSPasteboard.general.setString(result, forType: .string)
}

class BundleFinder {}
