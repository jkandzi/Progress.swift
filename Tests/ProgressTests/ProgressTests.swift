//
//  ProgressTests.swift
//  ProgressTests
//
//  Created by Justus Kandzi on 31/12/15.
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

import XCTest
import Progress

class ProgressBarTestPrinter: ProgressBarPrinter {
    var lastValue: String = ""
    
    func display(_ progressBar: ProgressBar) {
        lastValue = progressBar.value
    }
}

class ProgressTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

        ProgressBar.defaultConfiguration = [ProgressIndex(), ProgressBarLine(), ProgressTimeEstimates()]
    }

    func testProgressDefaultConfiguration() {
        let testPrinter = ProgressBarTestPrinter()
        var bar = ProgressBar(count: 2, printer: testPrinter)

        bar.next()
        XCTAssertEqual(testPrinter.lastValue, "0 of 2 [                              ] ETA: 00:00:00 (at 0.00) it/s)")
        bar.next()
        XCTAssertTrue(testPrinter.lastValue.hasPrefix("1 of 2 [---------------               ] ETA: "))
    }
    
    func testProgressDefaultConfigurationUpdate() {
        ProgressBar.defaultConfiguration = [ProgressPercent()]
        
        let bar = ProgressBar(count: 2)
        XCTAssertEqual(bar.value, "0%")
    }

    
    func testProgressConfiguration() {
        let testPrinter = ProgressBarTestPrinter()
        var bar = ProgressBar(count: 2, configuration: [ProgressString(string: "percent done:"), ProgressPercent()], printer: testPrinter)
        
        bar.next()
        XCTAssertEqual(testPrinter.lastValue, "percent done: 0%")
        bar.next()
        XCTAssertEqual(testPrinter.lastValue, "percent done: 50%")
    }
    
    func testProgressBarCountZero() {
        let bar = ProgressBar(count: 0)
        
        XCTAssertEqual(bar.value, "0 of 0 [------------------------------] ETA: 00:00:00 (at 0.00) it/s)")
    }
    
    func testProgressBarOutOfBounds() {
        let testPrinter = ProgressBarTestPrinter()

        var bar = ProgressBar(count: 2, configuration: [ProgressIndex()], printer: testPrinter)
        for _ in 0...10 {
            bar.next()
        }
        
        XCTAssertEqual(testPrinter.lastValue, "2 of 2")
    }

    func testProgressBarCustomIndex() {
        let testPrinter = ProgressBarTestPrinter()

        var bar = ProgressBar(count: 100, configuration: [ProgressIndex()], printer: testPrinter)
        for _ in 0...10 {
            bar.next()
        }

        bar.setValue(30)

        XCTAssertEqual(testPrinter.lastValue, "30 of 100")

        bar.setValue(1)

        XCTAssertEqual(testPrinter.lastValue, "1 of 100")

        bar.setValue(-5)

        XCTAssertEqual(testPrinter.lastValue, "1 of 100")

        bar.setValue(100)

        XCTAssertEqual(testPrinter.lastValue, "100 of 100")

        bar.setValue(10000)

        XCTAssertEqual(testPrinter.lastValue, "100 of 100")

        bar.setValue(0)

        XCTAssertEqual(testPrinter.lastValue, "0 of 100")
    }
    
    func testProgressGenerator() {
        let testPrinter = ProgressBarTestPrinter()
        let progress = Progress(6...7, configuration: [ProgressIndex()], printer: testPrinter)
        
        var generator = progress.makeIterator()
        
        XCTAssertEqual(generator.next(), 6)
        XCTAssertEqual(testPrinter.lastValue, "0 of 2")
        XCTAssertEqual(generator.next(), 7)
        XCTAssertEqual(testPrinter.lastValue, "1 of 2")
        XCTAssertEqual(generator.next(), nil)
        XCTAssertEqual(testPrinter.lastValue, "2 of 2")
    }
    
    func testProgressBarPerformance() {
        measure {
            for _ in Progress(1...100000) {}
        }
    }
}
