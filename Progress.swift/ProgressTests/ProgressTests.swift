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
    
    func testPercentElement() {
        var bar = ProgressBar(count: 10)
        bar.next()
        let percent = ProgressPercent()
        
        XCTAssert(percent.value(bar) == "10%")
    }
    
}
