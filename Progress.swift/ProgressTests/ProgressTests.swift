//
//  ProgressTests.swift
//  ProgressTests
//
//  Created by Justus Kandzi on 31/12/15.
//  Copyright © 2015 Justus Kandzi. All rights reserved.
//

import XCTest
import Progress

class ProgressTests: XCTestCase {
    
    override func setUp() {
        super.setUp()

        ProgressBar.defaultConfiguration = [ProgressIndex(), ProgressBarLine(), ProgressTimeEstimates()]
    }

    func testPercentElement() {
        var bar = ProgressBar(count: 10)
        bar.next()
        let percent = ProgressPercent()
        
        XCTAssertEqual(percent.value(bar), "10%")
    }
    
    func testPercentElementDecimalPlaces() {
        var bar = ProgressBar(count: 10)
        bar.next()
        bar.next()
        let percent = ProgressPercent(decimalPlaces: 4)
        
        XCTAssertEqual(percent.value(bar), "20.0000%")
    }
    
    func testPercentElementWithProgressBarCountZero() {
        let bar = ProgressBar(count: 0)
        let percent = ProgressPercent()
        XCTAssertEqual(percent.value(bar), "100%")
    }
    
    func testIndexElement() {
        var bar = ProgressBar(count: 1)
        let index = ProgressIndex()
        
        XCTAssertEqual(index.value(bar), "0 of 1")
        
        bar.next()
        XCTAssertEqual(index.value(bar), "1 of 1")
    }
    
    func testStringElement() {
        let bar = ProgressBar(count: 1)
        let stringElement = ProgressString(string: "test")
        
        XCTAssertEqual(stringElement.value(bar), "test")
    }
    
    func testBarLine() {
        var bar = ProgressBar(count: 3)
        let barLine = ProgressBarLine()
        
        XCTAssertEqual(barLine.value(bar), "[                              ]")
        
        bar.next()
        
        XCTAssertEqual(barLine.value(bar), "[----------                    ]")
        
        bar.next()
        bar.next()
        
        XCTAssertEqual(barLine.value(bar), "[------------------------------]")
    }
    
    func testBarLineLength() {
        var bar = ProgressBar(count: 10)
        let barLine = ProgressBarLine(barLength: 0)
        
        bar.next()
        
        XCTAssertEqual(barLine.value(bar), "[]")
    }
    
    func testTimeEstimates() {
        let bar = ProgressBar(count: 10000)
        let timeEstimates = ProgressTimeEstimates()
        
        XCTAssertEqual(timeEstimates.value(bar), "ETA: 00:00:00 (at 0.00) it/s)")
    }
    
    func testProgressDefaultConfiguration() {
        var bar = ProgressBar(count: 2)
        XCTAssertEqual(bar.value, "0 of 2 [                              ] ETA: 00:00:00 (at 0.00) it/s)")
        bar.next()
        XCTAssertTrue(bar.value.hasPrefix("1 of 2 [---------------               ] ETA: "))
    }
    
    func testProgressDefaultConfigurationUpdate() {
        ProgressBar.defaultConfiguration = [ProgressPercent()]
        
        let bar = ProgressBar(count: 2)
        XCTAssertEqual(bar.value, "0%")
    }

    
    func testProgressConfiguration() {
        var bar = ProgressBar(count: 2, configuration: [ProgressString(string: "percent done:"), ProgressPercent()])
        bar.next()
        
        XCTAssertEqual(bar.value, "percent done: 50%")
    }
    
    func testProgressBarCountZero() {
        let bar = ProgressBar(count: 0)
        
        XCTAssertEqual(bar.value, "0 of 0 [------------------------------] ETA: 00:00:00 (at 0.00) it/s)")
    }
    
    func testProgressBarOutOfBounds() {
        var bar = ProgressBar(count: 2, configuration: [ProgressIndex()])
        for _ in 0...10 {
            bar.next()
        }
        XCTAssertEqual(bar.value, "2 of 2")
    }
}
