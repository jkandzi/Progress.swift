//
//  Utilities.swift
//  Progress.swift
//
//  Created by Justus Kandzi on 04/01/16.
//  Copyright © 2016 Justus Kandzi. All rights reserved.
//

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

func getTimeOfDay() -> Double {
    var tv = timeval()
    gettimeofday(&tv, nil)
    return Double(tv.tv_sec) + Double(tv.tv_usec) / 1000000
}

extension Double {
    func format(decimalPartLength: Int, minimumIntegerPartLength: Int = 0) -> String {
        let value = String(self)
        let components = value.characters
            .split() { $0 == "." }
            .map { String($0) }
        
        guard var integerPart = components.first else {
            return stringWithZeros(minimumIntegerPartLength)
        }
        
        let missingLeadingZeros = minimumIntegerPartLength - integerPart.characters.count
        if missingLeadingZeros > 0 {
            integerPart += stringWithZeros(missingLeadingZeros)
        }
        
        if decimalPartLength == 0 {
            return integerPart
        }
        
        var decimalPlaces = components.last?.substringWithRange(0, end: decimalPartLength) ?? "0"
        let missingPlaceCount = decimalPartLength - decimalPlaces.characters.count
        decimalPlaces += stringWithZeros(missingPlaceCount)
        
        return "\(integerPart).\(decimalPlaces)"
    }
    
    private func stringWithZeros(count: Int) -> String {
        return Array(count: count, repeatedValue: "0").joinWithSeparator("")
    }
}

extension String {
    func substringWithRange(start: Int, end: Int) -> String {
        var end = end
        if start < 0 || start > self.characters.count {
            return ""
        }
        else if end < 0 || end > self.characters.count {
            end = self.characters.count
        }
        let range = Range(start: self.startIndex.advancedBy(start), end: self.startIndex.advancedBy(end))
        return self[range]
    }
}
