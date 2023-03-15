//
//  ProgressElementsTests.swift
//  Progress.swift
//
//  Created by Justus Kandzi on 04/01/16.
//  Copyright © 2016 Justus Kandzi. All rights reserved.
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

class ProgressElementsTests: XCTestCase {

    func testPercentElement() {
        var bar = ProgressBar(count: 10, printer: ProgressBarTestPrinter())
        bar.next()
        let percent = ProgressPercent()
        
        XCTAssertEqual(percent.value(bar), "10%")
    }
    
    func testPercentElementDecimalPlaces() {
        var bar = ProgressBar(count: 10, printer: ProgressBarTestPrinter())
        bar.next()
        bar.next()
        let percent = ProgressPercent(decimalPlaces: 4)
        
        XCTAssertEqual(percent.value(bar), "20.0000%")
    }
    
    func testPercentElementWithProgressBarCountZero() {
        let bar = ProgressBar(count: 0, printer: ProgressBarTestPrinter())
        let percent = ProgressPercent()
        XCTAssertEqual(percent.value(bar), "100%")
    }
    
    func testIndexElement() {
        var bar = ProgressBar(count: 1, printer: ProgressBarTestPrinter())
        let index = ProgressIndex()
        
        XCTAssertEqual(index.value(bar), "0 of 1")
        
        bar.next()
        XCTAssertEqual(index.value(bar), "1 of 1")
    }
    
    func testStringElement() {
        let bar = ProgressBar(count: 1, printer: ProgressBarTestPrinter())
        let stringElement = ProgressString(string: "test")
        
        XCTAssertEqual(stringElement.value(bar), "test")
    }
    
    func testBarLine() {
        var bar = ProgressBar(count: 3, printer: ProgressBarTestPrinter())
        let barLine = ProgressBarLine()
        
        XCTAssertEqual(barLine.value(bar), "[                              ]")
        
        bar.next()
        
        XCTAssertEqual(barLine.value(bar), "[----------                    ]")
        
        bar.next()
        bar.next()
        
        XCTAssertEqual(barLine.value(bar), "[------------------------------]")
    }
    
    func testBarLineLength() {
        var bar = ProgressBar(count: 10, printer: ProgressBarTestPrinter())
        let barLine = ProgressBarLine(barLength: 0)
        
        bar.next()
        
        XCTAssertEqual(barLine.value(bar), "[]")
    }
    
    func testTimeEstimates() {
        let bar = ProgressBar(count: 10000, printer: ProgressBarTestPrinter())
        let timeEstimates = ProgressTimeEstimates()
        
        XCTAssertEqual(timeEstimates.value(bar), "ETA: 00:00:00 (at 0.00) it/s)")
    }
}
