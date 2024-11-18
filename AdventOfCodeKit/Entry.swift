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
    
    do {
        let response = try await URLSession.shared.data(for: request)
        guard let httpResponse = response.1 as? HTTPURLResponse else {
            NSLog("Unknown response type: Expected HTTPURLResponse, got \(response.1.className)")
            return nil
        }
        guard httpResponse.statusCode == 200 else {
            NSLog("Unexpected status code: Expected 200, got \(httpResponse.statusCode)")
            return nil
        }
        let string = String(data: response.0, encoding: .utf8)
        
        try string?.write(to: inputUrl(for: day), atomically: true, encoding: .utf8)
        return string
    } catch {
        NSLog(error.localizedDescription)
        return nil
    }
}

public func run(_ day: String?, _ year: String?, _ cookie: String?) async {
    guard let day else {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "EST")!
        
        let components = calendar.dateComponents([.day, .year], from: Date())
        await run(components.day?.description, year ?? components.year?.description, cookie)
        return
    }
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
