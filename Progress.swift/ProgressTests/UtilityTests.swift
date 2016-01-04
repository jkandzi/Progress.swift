//
//  UtilityTests.swift
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
@testable import Progress

class UtilityTests: XCTestCase {

    // MARK: - Substring
    func testSubstringEndOutOfBounds() {
        XCTAssertEqual("abc".substringWithRange(2, end: 100), "c")
    }
    
    func testSubstringStartOutOfBounds() {
        XCTAssertEqual("abc".substringWithRange(3, end: 100), "")
        XCTAssertEqual("abc".substringWithRange(10, end: 100), "")
    }
    
    // MARK: - format double
    func testFormat() {
        XCTAssertEqual(Double(0.0).format(0), "0")
        XCTAssertEqual(Double(0.0).format(1), "0.0")
        XCTAssertEqual(Double(0.0).format(3), "0.000")
        
        XCTAssertEqual(Double(0.0).format(0, minimumIntegerPartLength: 1), "0")
        XCTAssertEqual(Double(0.0).format(0, minimumIntegerPartLength: 2), "00")
        XCTAssertEqual(Double(0.0).format(3, minimumIntegerPartLength: 3), "000.000")

        XCTAssertEqual(Double(100.0).format(0, minimumIntegerPartLength: 1), "100")
        XCTAssertEqual(Double(100.0).format(0, minimumIntegerPartLength: 2), "100")
        XCTAssertEqual(Double(100.0).format(1, minimumIntegerPartLength: 4), "0100.0")
    }
}
