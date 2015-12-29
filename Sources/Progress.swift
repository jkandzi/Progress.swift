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

// MARK: - ProgressElements


public protocol ProgressElementType {
    func value(progressBar: ProgressBar) -> String
}


/// creates the progress bar element e.g. "[----------------------        ]"
public struct ProgressBarLine: ProgressElementType {
    let barLength: Int

    init(barLength: Int = 30) {
        self.barLength = barLength
    }
    
    public func value(progressBar: ProgressBar) -> String {
        var completedBarElements = 0
        if progressBar.count == 0 {
            completedBarElements = barLength
        } else {
            completedBarElements = Int(Double(barLength) * (Double(progressBar.index) / Double(progressBar.count)))
        }
        
        var barArray = [String](count: completedBarElements, repeatedValue: "-")
        barArray += [String](count: barLength - completedBarElements, repeatedValue: " ")
        return "[" + barArray.joinWithSeparator("") + "]"
    }
}


/// creates the index element e.g. "2 of 3"
public struct ProgressIndex: ProgressElementType {
    public func value(progressBar: ProgressBar) -> String {
        return "\(progressBar.index) of \(progressBar.count)"
    }
}


public struct ProgressPercent: ProgressElementType {
    public func value(progressBar: ProgressBar) -> String {
        let percentDone = Double(progressBar.index) / Double(progressBar.count) * 100
        return String(format: "%.1f%%", percentDone)
    }
}


/// creates the time estimates e.g. "ETA: 00:00:02 (at 1.00 it/s)"
public struct ProgressTimeEstimates: ProgressElementType {
    public func value(progressBar: ProgressBar) -> String {
        let totalTime = CFAbsoluteTimeGetCurrent() - progressBar.startTime
        
        var itemsPerSecond = 0.0
        var estimatedTimeRemaining = 0.0
        if progressBar.index > 0 {
            itemsPerSecond = totalTime / Double(progressBar.index)
            estimatedTimeRemaining = itemsPerSecond * Double(progressBar.count - progressBar.index)
        }
        
        let estimatedTimeRemainingString = formatDuration(estimatedTimeRemaining)
        
        return String(format: "ETA: %@ (at %.2f) it/s)", estimatedTimeRemainingString, itemsPerSecond)
    }

    private func formatDuration(duration: NSTimeInterval) -> String {
        let duration = Int(duration)
        let seconds = duration % 60
        let minutes = (duration / 60) % 60
        let hours = (duration / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

// MARK: - ProgressBar


public struct ProgressBar {
    var index = 0
    let startTime = CFAbsoluteTimeGetCurrent()
    let count: Int
    let configuration: [ProgressElementType]?

    static var defaultConfiguration: [ProgressElementType] = [ProgressIndex(), ProgressBarLine(), ProgressTimeEstimates()]
    
    init(count: Int, configuration: [ProgressElementType]? = nil) {
        self.count = count
        self.configuration = configuration
        
        // the cursor is moved up before printing the progress bar.
        // have to move the cursor down one line initially.
        print("")
    }
    
    mutating func next() {
        let configuration = self.configuration ?? ProgressBar.defaultConfiguration
        let string: String = configuration.reduce("", combine: { $0 + " " + $1.value(self) })
        print("\u{1B}[1A\u{1B}[K\(string)")

        index += 1
    }
}

// MARK: - GeneratorType


public struct ProgressGenerator<G: GeneratorType>: GeneratorType {
    var source: G
    var progressBar: ProgressBar
    
    init(source: G, count: Int, configuration: [ProgressElementType]? = nil) {
        self.source = source
        self.progressBar = ProgressBar(count: count, configuration: configuration)
    }
    
    public mutating func next() -> G.Element? {
        progressBar.next()
        return source.next()
    }
}

// MARK: - SequenceType


public struct Progress<G: SequenceType>: SequenceType {
    let generator: G
    let configuration: [ProgressElementType]?
    
    public init(_ generator: G, configuration: [ProgressElementType]? = nil) {
        self.generator = generator
        self.configuration = configuration
    }
    
    public func generate() -> ProgressGenerator<G.Generator> {
        let count = generator.underestimateCount()
        return ProgressGenerator(source: generator.generate(), count: count, configuration: configuration)
    }
}
