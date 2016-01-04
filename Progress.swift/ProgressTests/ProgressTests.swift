//
//  ProgressTests.swift
//  ProgressTests
//
//  Created by Justus Kandzi on 31/12/15.
//  Copyright © 2015 Justus Kandzi. All rights reserved.
//

import XCTest
import Progress

class ProgressBarTestPrinter: ProgressBarPrinter {
    var lastValue: String = ""
    
    func display(progressBar: ProgressBar) {
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
    
    func testProgressGenerator() {
        let testPrinter = ProgressBarTestPrinter()
        let progress = Progress(6...7, configuration: [ProgressIndex()], printer: testPrinter)
        
        var generator = progress.generate()
        
        XCTAssertEqual(generator.next(), 6)
        XCTAssertEqual(testPrinter.lastValue, "0 of 2")
        XCTAssertEqual(generator.next(), 7)
        XCTAssertEqual(testPrinter.lastValue, "1 of 2")
        XCTAssertEqual(generator.next(), nil)
        XCTAssertEqual(testPrinter.lastValue, "2 of 2")
    }
    
    func testProgressBarPerformance() {
        measureBlock {
            for _ in Progress(1...100000) {}
        }
    }
}
