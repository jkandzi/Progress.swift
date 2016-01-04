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

// MARK: - ProgressBar

public struct ProgressBar {
    var index = 0
    let startTime = getTimeOfDay()
    var lastPrintedTime = 0.0
    
    let count: Int
    let configuration: [ProgressElementType]?
    
    public var value: String {
        let configuration = self.configuration ?? ProgressBar.defaultConfiguration
        let values = configuration.map { $0.value(self) }
        return values.joinWithSeparator(" ")
    }
    
    public static var defaultConfiguration: [ProgressElementType] = [ProgressIndex(), ProgressBarLine(), ProgressTimeEstimates()]
    
    public init(count: Int, configuration: [ProgressElementType]? = nil) {
        self.count = count
        self.configuration = configuration
        
        // the cursor is moved up before printing the progress bar.
        // have to move the cursor down one line initially.
        print("")
    }
    
    public mutating func next() {
        guard index <= count else { return }
        
        let currentTime = getTimeOfDay()
        if (currentTime - lastPrintedTime > 0.1 || index == count) {
            print("\u{1B}[1A\u{1B}[K\(value)")
            lastPrintedTime = currentTime
        }
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
