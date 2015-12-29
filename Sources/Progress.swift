//
//  Progress.swift
//
//  Created by Justus Kandzi on 27/12/15.
//  Copyright © 2015 Justus Kandzi. All rights reserved.
//
//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

public struct ProgressGenerator<G: GeneratorType>: GeneratorType {
    var source: G
    var index = 0
    let startTime = CFAbsoluteTimeGetCurrent()
    let barLength = 30
    let count: Int
    
    init(source: G, count: Int) {
        self.source = source
        self.count = count
    }
    
    public mutating func next() -> G.Element? {
        let string = [indexInformation(), progressBar(), timeEstimates()].joinWithSeparator(" ")
        
        if index == 0 {
            // "\u{1B}[1A" moves the cursor up one line. have to add an empty line here.
            print("")
        }
        
        print("\u{1B}[1A\u{1B}[K\(string)")
        
        index += 1
        return source.next()
    }
    
    /// creates the index element e.g. "2 of 3"
    private func indexInformation() -> String {
        return "\(index) of \(count)"
    }
    
    /// creates the progress bar element e.g. "[----------------------        ]"
    private func progressBar() -> String {
        var completedBarElements = 0
        if count == 0 {
            completedBarElements = barLength
        }
        else {
            completedBarElements = Int(Double(barLength) * (Double(index) / Double(count)))
        }
        
        var barArray = [String](count: completedBarElements, repeatedValue: "-")
        barArray += [String](count: barLength - completedBarElements, repeatedValue: " ")
        return "[" + barArray.joinWithSeparator("") + "]"
    }
    
    /// creates the time estimates e.g. "ETA: 00:00:02 (at 1.00 it/s)"
    private func timeEstimates() -> String {
        let totalTime = CFAbsoluteTimeGetCurrent() - startTime
        
        var itemsPerSecond = 0.0
        var estimatedTimeRemaining = 0.0
        if index > 0 {
            itemsPerSecond = totalTime / Double(index)
            estimatedTimeRemaining = itemsPerSecond * Double(count - index)
        }
        
        return "ETA: \(formatDuration(estimatedTimeRemaining)) (at \(formatDouble(itemsPerSecond, ".2")) it/s)"
    }
    
    private func formatDouble(value: Double, _ format: String) -> String {
        return String(format: "%\(format)f", value)
    }
    
    private func formatDuration(duration: NSTimeInterval) -> String {
        let duration = Int(duration)
        let seconds = duration % 60
        let minutes = (duration / 60) % 60
        let hours = (duration / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

public struct Progress<G: SequenceType>: SequenceType {
    let generator: G
    
    public init(_ generator: G) {
        self.generator = generator
    }
    
    public func generate() -> ProgressGenerator<G.Generator> {
        let count = generator.underestimateCount()
        return ProgressGenerator(source: generator.generate(), count: count)
    }
}
