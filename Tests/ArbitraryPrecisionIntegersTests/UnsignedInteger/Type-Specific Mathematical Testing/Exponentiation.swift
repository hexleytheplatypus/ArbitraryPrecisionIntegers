//
//  File.swift
//  
//
//  Created by Annovae on 9/25/23.
//

import Foundation


import XCTest
@testable import ArbitraryPrecisionIntegers

final class PrecisionUIntExponentiationTests: XCTestCase {
    func testExponentiationAccuracy() {
        let x = Unsigned(2).exponent(8)
        XCTAssertEqual(x, Unsigned(256))
        
        let y = Unsigned(2).exponent(9)
        XCTAssertEqual(y, Unsigned(512))
        
        let z = Unsigned(2).exponent(10)
        XCTAssertEqual(z, Unsigned(1024))
        
        
        let a = Unsigned(3).exponent(5)
        XCTAssertEqual(a, Unsigned(243))
        
        let b = Unsigned(7).exponent(11)
        XCTAssertEqual(b, Unsigned(1977326743))
        
        let c = Unsigned(13).exponent(16)
        XCTAssertEqual(c, Unsigned(665416609183179841))
    }
}
