import XCTest
@testable import ArbitraryPrecisionIntegers

final class PrecisionIntTests: XCTestCase {
    let types: [any _APSI_TestProtocol.Type] = [
        ArbitraryPrecisionSignedInteger.self,
    ]
    
    func testInitialization() {
        func initialization<T: _APSI_TestProtocol>(_ typed: T.Type) {
            let a = T(100 as UInt8)
            XCTAssertEqual(a, 100)
            XCTAssertTrue(a == 100)
            XCTAssertEqual(a.description, "100")

            let b = T(1_000 as UInt16)
            XCTAssertEqual(b, 1_000)

            let c = T(1_000_000 as UInt32)
            XCTAssertEqual(c, 1_000_000)

            let d = T(1_000_000_000 as UInt64)
            XCTAssertEqual(d, 1_000_000_000)

            let x = -T(1_000_000 as UInt)
            XCTAssertEqual(x, -1_000_000)

            let y: T = 1_000_000_000_000_000_000_000_000_000_000_000_000
            XCTAssertEqual(y, 1_000_000_000_000_000_000_000_000_000_000_000_000)
            XCTAssertEqual(y.decimalString, "1000000000000000000000000000000000000", "\(T.ArchitectureWidth.self)")

            let y2 = T("1000000000000000000000000000000000000")!
            XCTAssertEqual(y2.decimalString, "1000000000000000000000000000000000000", "\(T.ArchitectureWidth.self)")
            XCTAssertEqual(y2, 1_000_000_000_000_000_000_000_000_000_000_000_000, "\(T.ArchitectureWidth.self)")
            
            let y3: T = -1_000_000_000_000_000_000_000_000_000_000_000_000
            XCTAssertEqual(-y3, y)
            XCTAssertEqual(-y3, 1_000_000_000_000_000_000_000_000_000_000_000_000, "\(T.ArchitectureWidth.self)")
            XCTAssertEqual(y3.decimalString, "-1000000000000000000000000000000000000", "\(T.ArchitectureWidth.self)")

            let y4 = T("-1000000000000000000000000000000000000")!
            XCTAssertEqual(y4.decimalString, "-1000000000000000000000000000000000000", "\(T.ArchitectureWidth.self)")
            XCTAssertEqual(y4, -1_000_000_000_000_000_000_000_000_000_000_000_000, "\(T.ArchitectureWidth.self)")
            
            let z = x * x * x * x * x * x
            if T.ArchitectureWidth.self == UInt64.self {
                XCTAssertEqual(z._mantissa._storage, [12919594847110692864, 54210108624275221], "\(T.ArchitectureWidth.self)")
            }
            XCTAssertTrue(y == z, "\(T.ArchitectureWidth.self)")
            XCTAssertEqual(y, z, "\(T.ArchitectureWidth.self)")
        }
        
        for type in types { initialization(type) }
    }

    func testFixedPointIdentity() {
        func fixedPointIdentity<T: _APSI_TestProtocol>(_ typed: T.Type) {
            let x: T = T.random(in: 1...9)
            let y = -x

            /// Unmodified Assignment of a value is always equal the original value
            XCTAssertEqual(-x, y)
            XCTAssertEqual(-y, x)

            /// Addition of a number and 0 always equals the number itself
            XCTAssertEqual(x + 0, x)
            XCTAssertEqual(y + 0, y)

            /// Subtraction of 0 from a number always equals the number itself
            XCTAssertEqual(x - 0, x)
            XCTAssertEqual(y - 0, y)

            /// Subtraction of a number from itself is always 0
            XCTAssertEqual(x - x, 0)
            XCTAssertEqual(y - y, 0)

            /// Multiplication of a number by 1 always equals itself
            XCTAssertEqual(x * 1, x)
            XCTAssertEqual(y * 1, y)
            XCTAssertEqual(x * -1, y)
            XCTAssertEqual(y * -1, x)

            /// Division of a number by itself is always 1
            XCTAssertEqual(x / x, 1)
            if x != .zero {
                XCTAssertEqual(x / y, -1)
                XCTAssertEqual(y / x, -1)
            }
            XCTAssertEqual(y / y, 1)

            /// Remainder of a number divided by itself is always 0
            XCTAssertEqual(x % x, 0)
            XCTAssertEqual(x % y, 0)
            XCTAssertEqual(y % x, 0)
            XCTAssertEqual(y % y, 0)

            /// Equatability of a number and itself is true
            XCTAssertTrue(x == x)
            XCTAssertTrue(y == y)
            XCTAssertTrue(-x == y)

            /// Comparability, a number is never GreaterThan or LessThan itself
            XCTAssertFalse(x > x)
            XCTAssertFalse(-x > y)
            XCTAssertFalse(y > y)
            XCTAssertFalse(x < x)
            XCTAssertFalse(-x < y)
            XCTAssertFalse(y < y)

            /// Convertiblity
            let init_int = Int(T(-10))
            let init_int8 = Int8(T(-10))
            let init_int16 = Int16(T(-10))
            let init_int32 = Int32(T(-10))
            let init_int64 = Int64(T(-10))
            XCTAssertEqual(init_int, -10)
            XCTAssertEqual(init_int8, -10)
            XCTAssertEqual(init_int16, -10)
            XCTAssertEqual(init_int32, -10)
            XCTAssertEqual(init_int64, -10)
            XCTAssertEqual(init_int.description, "-10", "\(T.ArchitectureWidth.self)")
            XCTAssertEqual(init_int8.description, "-10", "\(T.ArchitectureWidth.self)")
            XCTAssertEqual(init_int16.description, "-10", "\(T.ArchitectureWidth.self)")
            XCTAssertEqual(init_int32.description, "-10", "\(T.ArchitectureWidth.self)")
            XCTAssertEqual(init_int64.description, "-10", "\(T.ArchitectureWidth.self)")
            
            if T.ArchitectureWidth.self == UInt64.self {
                let x: T = -1_000_000_010_000_000_001_000_000_010_000_000_001_000_000_010_000_000_001
                let trunc_int = Int(truncatingIfNeeded: x)
                let trunc_int8 = Int8(truncatingIfNeeded: x)
                let trunc_int16 = Int16(truncatingIfNeeded: x)
                let trunc_int32 = Int32(truncatingIfNeeded: x)
                let trunc_int64 = Int64(truncatingIfNeeded: x)
                XCTAssertEqual(trunc_int, -66313912990032897, "\(T.ArchitectureWidth.self)")
                XCTAssertEqual(trunc_int8, -1, "\(T.ArchitectureWidth.self)")
                XCTAssertEqual(trunc_int16, 7167, "\(T.ArchitectureWidth.self)")
                XCTAssertEqual(trunc_int32, -191882241, "\(T.ArchitectureWidth.self)")
                XCTAssertEqual(trunc_int64, -66313912990032897, "\(T.ArchitectureWidth.self)")
            }
    }
        
        for type in types { fixedPointIdentity(type) }
    }

    func testBasicArithmetic() {
        func basicArithmetic<T: _APSI_TestProtocol>(_ typed: T.Type) {
            let x = T.random(in: 1...9)
            let y = -T.random(in: 1...9)
            let (q, r) = x.quotientAndRemainder(dividingBy: y)
            
            XCTAssertEqual(q * y + r, x)
            XCTAssertEqual(q * y, x - r)
        }
        
        for type in types { basicArithmetic(type) }
    }

    func testZeroArithmetic() {
        func zeroArithmetic<T: _APSI_TestProtocol>(_ typed: T.Type) {
        let zero: T = 0
        XCTAssertTrue(zero.isZero)
        XCTAssertFalse(zero.isNegative)
        
        let x: T = 1
        XCTAssertTrue((x - x).isZero)
        XCTAssertFalse((x - x).isNegative)
        
        let y: T = -1
        XCTAssertTrue(y.isNegative)
        XCTAssertTrue((y - y).isZero)
        XCTAssertFalse((y - y).isNegative)
        
        XCTAssertEqual(x * zero, zero)
        /// `XCTest` cannot currently test for `Swift` `precondition`s
        // XCTExpectFailure(x / zero, precondition: "Division by zero in quotient operation")
        // XCTExpectFailure(x % zero, precondition: "Division by zero in remainder operation")
    }
        
        for type in types { zeroArithmetic(type) }
    }
    
    func testOverflowMinimums() {
        func overflowMinimums<T: _APSI_TestProtocol>(_ typed: T.Type) {
            var max = -T(T.ArchitectureWidth.max)
            max -= 1
            XCTAssertEqual(max._mantissa._storage.count, 2)
        }
        
        for type in types { overflowMinimums(type) }
    }

    func testConformances() {
        func conformances<T: _APSI_TestProtocol>(_ typed: T.Type) {
            // Comparable
            let x = T(T.ArchitectureWidth.max)
            let y = x * x * x * x * x
            XCTAssertLessThan(y, y + 1)
            XCTAssertGreaterThan(y, y - 1)
            XCTAssertGreaterThan(y, 0)
            
            let z = -y
            XCTAssertLessThan(z, z + 1)
            XCTAssertGreaterThan(z, z - 1)
            XCTAssertLessThan(z, 0)
            
            XCTAssertEqual(-z, y)
            XCTAssertEqual(y + z, 0)
            
            // Hashable
            XCTAssertNotEqual(x.hashValue, y.hashValue)
            XCTAssertNotEqual(y.hashValue, z.hashValue)
            
            let set = Set([x, y, z])
            XCTAssertTrue(set.contains(x))
            XCTAssertTrue(set.contains(y))
            XCTAssertTrue(set.contains(z))
            XCTAssertFalse(set.contains(-x))
        }
        
        for type in types { conformances(type) }
    }

    func testBinaryIntegerInterop() {
        func binaryIntegerInterop<T: _APSI_TestProtocol>(_ typed: T.Type) {
            let x: T = 100
            let xComp = UInt8(x)
            XCTAssertTrue(x == xComp)
            XCTAssertTrue(x < xComp + 1)
            XCTAssertFalse(xComp + 1 < x)
            
            let y: T = -100
            let yComp = Int8(y)
            XCTAssertTrue(y == yComp)
            XCTAssertTrue(y < yComp + (1 as Int8))
            XCTAssertFalse(yComp + (1 as Int8) < y)
            XCTAssertTrue(y < yComp + 1)
            
            let zComp = Int.min + 1
            let z = T(zComp)
            XCTAssertTrue(z == zComp)
            XCTAssertTrue(zComp == z)
            XCTAssertFalse(zComp + 1 < z)
            XCTAssertTrue(z < zComp + 1)
            
            let w = T(UInt.max)
            let wComp = UInt(truncatingIfNeeded: w)
            XCTAssertTrue(w == wComp)
            XCTAssertTrue(wComp == w)
            XCTAssertTrue(wComp - (1 as UInt) < w)
            XCTAssertFalse(w < wComp - (1 as UInt))
            
            XCTAssertTrue(wComp - 1 < w)
            XCTAssertTrue(w > wComp - 1)
        }
        
        for type in types { binaryIntegerInterop(type) }
    }

    func testHuge() {
        func huge<T: _APSI_TestProtocol>(_ typed: T.Type) {
            let x = -T.random(in: 1...9)
            XCTAssertLessThan(x, x + 1)
            let y = x
            XCTAssertLessThan(y, y + 1)
        }
        
        for type in types { huge(type) }
    }

    func testNumeric() {
        func numeric<T: _APSI_TestProtocol>(_ typed: T.Type) {
        let data = [
            ("3GFWFN54YXNBS6K2ST8K9B89Q2AMRWCNYP4JAS5ZOPPZ1WU09MXXTIT27ZPVEG2Y", "9Y1QXS4XYYDSBMU4N3LW7R3R1WKK", "CIFJIVHV0K4MSX44QEX2US0MFFEAWJVQ8PJZ", "26HILZ7GZQN8MB4O17NSPO5XN1JI"),
            ("7PM82EHP7ZN3ZL7KOPB7B8KYDD1R7EEOYWB6M4SEION47EMS6SMBEA0FNR6U9VAM70HPY4WKXBM8DCF1QOR1LE38NJAVOPOZEBLIU1M05", "-202WEEIRRLRA9FULGA15RYROVW69ZPDHW0FMYSURBNWB93RNMSLRMIFUPDLP5YOO307XUNEFLU49FV12MI22MLCVZ5JH", "-3UNIZHA6PAL30Y", "1Y13W1HYB0QV2Z5RDV9Z7QXEGPLZ6SAA2906T3UKA46E6M4S6O9RMUF5ETYBR2QT15FJZP87JE0W06FA17RYOCZ3AYM3"),
            ("-ICT39SS0ONER9Z7EAPVXS3BNZDD6WJA791CV5LT8I4POLF6QYXBQGUQG0LVGPVLT0L5Z53BX6WVHWLCI5J9CHCROCKH3B381CCLZ4XAALLMD", "6T1XIVCPIPXODRK8312KVMCDPBMC7J4K0RWB7PM2V4VMBMODQ8STMYSLIXFN9ORRXCTERWS5U4BLUNA4H6NG8O01IM510NJ5STE", "-2P2RVZ11QF", "-3YSI67CCOD8OI1HFF7VF5AWEQ34WK6B8AAFV95U7C04GBXN0R6W5GM5OGOO22HY0KADIUBXSY13435TW4VLHCKLM76VS51W5Z9J"),
            ("-326JY57SJVC", "-8H98AQ1OY7CGAOOSG", "0", "-326JY57SJVC"),
            ("-XIYY0P3X9JIDF20ZQG2CN5D2Q5CD9WFDDXRLFZRDKZ8V4TSLE2EHRA31XL3YOHPYLE0I0ZAV2V9RF8AGPCYPVWEIYWWWZ3HVDR64M08VZTBL85PR66Z2F0W5AIDPXIAVLS9VVNLNA6I0PKM87YW4T98P0K", "-BUBZEC4NTOSCO0XHCTETN4ROPSXIJBTEFYMZ7O4Q1REOZO2SFU62KM3L8D45Z2K4NN3EC4BSRNEE", "2TX1KWYGAW9LAXUYRXZQENY5P3DSVXJJXK4Y9DWGNZHOWCL5QD5PLLZCE6D0G7VBNP9YGFC0Z9XIPCB", "-3LNPZ9JK5PUXRZ2Y1EJ4E3QRMAMPKZNI90ZFOBQJM5GZUJ84VMF8EILRGCHZGXJX4AXZF0Z00YA"),
            ("AZZBGH7AH3S7TVRHDJPJ2DR81H4FY5VJW2JH7O4U7CH0GG2DSDDOSTD06S4UM0HP1HAQ68B2LKKWD73UU0FV5M0H0D0NSXUJI7C2HW3P51H1JM5BHGXK98NNNSHMUB0674VKJ57GVVGY4", "1LYN8LRN3PY24V0YNHGCW47WUWPLKAE4685LP0J74NZYAIMIBZTAF71", "6TXVE5E9DXTPTHLEAG7HGFTT0B3XIXVM8IGVRONGSSH1UC0HUASRTZX8TVM2VOK9N9NATPWG09G7MDL6CE9LBKN", "WY37RSPBTEPQUA23AXB3B5AJRIUL76N3LXLP3KQWKFFSR7PR4E1JWH"),
            ("1000000000000000000000000000000000000000000000", "1000000000000000000000000000000000000", "1000000000", "0"),
        ]

            for strings in data {
                let x = T(strings.0, radix: 36)!
                let y = T(strings.1, radix: 36)!
                let q = T(strings.2, radix: 36)!
                let r = T(strings.3, radix: 36)!
                
                let (testQ, testR) = x.quotientAndRemainder(dividingBy: y)
                XCTAssertEqual(testQ, q)
                XCTAssertEqual(testR, r)
                XCTAssertEqual(x, y * q + r)
            }
        }
        
        for type in types { numeric(type) }
    }

    func testStrings() {
        func strings<T: _APSI_TestProtocol>(_ typed: T.Type) {
            let x = T("-3UNIZHA6PAL30Y", radix: 36)!
            XCTAssertEqual(x.binaryString, "-1000111001110110011101001110000001011001110110011011110011000010010010")
            XCTAssertEqual(x.decimalString, "-656993338084259999890")
            XCTAssertEqual(x.hexString, "-239D9D3816766F3092")
            XCTAssertEqual(x.compactString, "-3UNIZHA6PAL30Y")
            
            XCTAssertTrue(T("12345") == 12345)
            XCTAssertTrue(T("-12345") == -12345)
            
            XCTAssertTrue(T("-3UNIZHA6PAL30Y", radix: 10) == nil)
            XCTAssertTrue(T("---") == nil)
            XCTAssertTrue(T(" 123") == nil)
            
            XCTAssertTrue(T.zero == 0)
            XCTAssertTrue(T.zero.hexString == "0")
            XCTAssertTrue(T.zero.description == "0")
            XCTAssertTrue(T.zero.decimalString == "0")
            XCTAssertTrue(T.zero.debugDescription == "ArbitraryPrecisionSignedInteger(0, storage: ArbitraryPrecisionUnsignedInteger(0, words: 0))")
        }
        
        for type in types { strings(type) }
    }

    func testRandomizedArithmetic() {
        func randomizedArithmetic<T: _APSI_TestProtocol>(_ typed: T.Type) {
            let range: ClosedRange<T.ArchitectureWidth> = 90...91
            for _ in 1...10 {
                // Test x == (x / y) * x + (x % y)
                let (x, y) = (T.random(in: range),
                              -T.random(in: range))
                
                if !y.isZero {
                    let (q, r) = x.quotientAndRemainder(dividingBy: y)
                    XCTAssertEqual(q * y + r, x)
                    XCTAssertEqual(q * y, x - r)
                }
                
                // Test (x0 + y0)(x1 + y1) == x0x1 + x0y1 + y0x1 + y0y1
                let (x0, y0, x1, y1) = (-T.random(in: range),
                                        -T.random(in: range),
                                        T.random(in: range),
                                        T.random(in: range))
                let r1 = (x0 + y0) * (x1 + y1)
                let r2 = ((x0 * x1) + (x0 * y1), (y0 * x1) + (y0 * y1))
                XCTAssertEqual(r1, r2.0 + r2.1)
            }
        }
        
        for type in types { randomizedArithmetic(type) }
    }

    func testZero() {
        func zero<T: _APSI_TestProtocol>(_ typed: T.Type) {
            /// Initialization
            XCTAssertEqual(T(0), 0)    /// Whole T
            //        XCTAssertEqual(T(0.0), 0)  /// Decimal T
            XCTAssertEqual(T.zero, 0)  /// Static Constant
            
            /// SE-0213
            let zer1: T = 0    /// via `ExpressibleByIntegerLiteral`
            let zer2 = 0 as T  /// via `as`, type coercion operator
            XCTAssertEqual(zer1, 0)
            XCTAssertEqual(zer2, 0)
            
            /// Property
            XCTAssertEqual(zer1.isZero, true)
            
            /// Negation Removal
            ///
            /// - `T` doesn't support the notion of `Signed Zero`
            /// (https://en.wikipedia.org/wiki/Signed_zero) as `T` never
            /// holds an internal representation matching or mimicking `IEEE 754`
            /// (https://en.wikipedia.org/wiki/IEEE_754) and therefore does not
            /// gain a performance benefit from `Signed Zero`.
            
            let int1: T = -0 /// Negative Integer
            XCTAssertEqual(int1, 0)
            XCTAssertEqual(int1.isNegative, false)
            
            /// Operations
            /// Addition
            XCTAssertEqual(zer1 + int1, zer2)
            
            /// Subtraction
            XCTAssertEqual(zer1 - int1, zer2)
            
            /// Multiplication
            XCTAssertEqual(zer1 * int1, zer2)
            
            /// Divison - `XCTest` cannot currently test for `Swift` `precondition`s
            // XCTExpectFailure(zer1 / int1, precondition: "Division by zero in quotient operation")
            
            /// Remainder - `XCTest` cannot currently test for `Swift` `precondition`s
            // XCTExpectFailure(zer1 % int1, precondition: "Division by zero in remainder operation")
            
            //        /// Exponentation
            //        XCTAssertEqual(zer1.power(exponent: int1), zer2)
            //
            //        /// Square Root
            //        XCTAssertEqual(zer1.squareRoot(), zer2)
            //
            //        /// Factorial
            //        XCTAssertEqual(zer1.factorial(), zer2)
        }
        
        for type in types { zero(type) }
    }
    
    func testRedundancy() {
        func redundancy<T: _APSI_TestProtocol>(_ typed: T.Type) {
            let nn1 = -T.random(in: 1...9)
            XCTAssertEqual(nn1 + nn1, nn1 * 2)
            XCTAssertEqual(nn1 - nn1, nn1 % nn1)
            XCTAssertEqual(nn1 / nn1, 1)
        }
        
        for type in types { redundancy(type) }
    }
    
    func testOverflow() {
        func overflow<T: _APSI_TestProtocol>(_ typed: T.Type) {
            let nn1 = -T(T.ArchitectureWidth.max)
            let nn2 = nn1 - 1
            XCTAssertEqual(nn2._mantissa._storage.count, 2)
            XCTAssertEqual(nn2 - nn1, -1)
            XCTAssertEqual(nn2 % nn1, -1)
        }
        
        for type in types { overflow(type) }
    }

    func testOperations() {
        func operations<T: _APSI_TestProtocol>(_ typed: T.Type) {
            /// Natural T
            let nn1: T = 2
            let nn2: T = 4
            XCTAssertEqual(nn1 + nn2, 6)
            XCTAssertEqual(nn1 - nn2, -2)
            XCTAssertEqual(nn2 - nn1, 2)
            XCTAssertEqual(nn1 * nn2, 8)
            XCTAssertEqual(nn1 / nn2, 0)
            XCTAssertEqual(nn2 / nn1, 2)
            
            /// Whole T
            let wn1: T = 8
            let wn2: T = 9
            XCTAssertEqual(wn1 + wn2, 17)
            XCTAssertEqual(wn1 - wn2, -1)
            XCTAssertEqual(wn2 - wn1, 1)
            XCTAssertEqual(wn1 * wn2, 72)
            XCTAssertEqual(wn1 / wn2, T(8) / T(9))
            XCTAssertEqual(wn2 / wn1, 1)
            
            /// Integer
            let n_in1: T = -(nn1)
            let n_in2: T = -nn2
            XCTAssertEqual(n_in1 + n_in2, -6)
            XCTAssertEqual(n_in1 - n_in2, 2)
            XCTAssertEqual(n_in1 * n_in2, 8)
            XCTAssertEqual(n_in1 / n_in2, 0)
            XCTAssertEqual(n_in2 / n_in1, 2)
        }
        
        for type in types { operations(type) }
    }

    func testNumericClassification() {
        func numericClassification<T: _APSI_TestProtocol>(_ typed: T.Type) {
            let nn1: T = 7
            XCTAssertEqual(nn1.isNegative, false)
            XCTAssertEqual(nn1.isZero, false)
            XCTAssertEqual(nn1.isNaturalNumber, true)
            XCTAssertEqual(nn1.isWholeNumber, true)
            XCTAssertEqual(nn1.isInteger, true)
            XCTAssertEqual(nn1.isRational, true)
            XCTAssertEqual(nn1.isRepeating, false)
            XCTAssertEqual(nn1.isIrrational, false)
            XCTAssertEqual(nn1.isRealNumber, true)
            XCTAssertEqual(nn1.isComplexNumber, false)
            
            let nn2: T = -7
            XCTAssertEqual(nn2.isNegative, true)
            XCTAssertEqual(nn2.isZero, false)
            XCTAssertEqual(nn2.isNaturalNumber, false)
            XCTAssertEqual(nn2.isWholeNumber, false)
            XCTAssertEqual(nn2.isInteger, true)
            XCTAssertEqual(nn2.isRational, true)
            XCTAssertEqual(nn2.isRepeating, false)
            XCTAssertEqual(nn2.isIrrational, false)
            XCTAssertEqual(nn2.isRealNumber, true)
            XCTAssertEqual(nn2.isComplexNumber, false)
        }
        
        for type in types { numericClassification(type) }
    }

    func testConstants() {
        func constants<T: _APSI_TestProtocol>(_ typed: T.Type) {
            XCTAssertEqual(T.one, 1)
            XCTAssertEqual(T.two, 2)
            XCTAssertEqual(T.ten, 10)
        }
        
        for type in types { constants(type) }
    }
    
    // MARK: - Bitwise Operations
    func testBitwiseOperations() {
        func bitwiseOperations<T: _APSI_TestProtocol>(_ typed: T.Type) {
            // MARK: - UInt8
            let uint8_max: T = T(UInt8.max) // (0b11111111)
            XCTAssertEqual(uint8_max << 16, 0b11111111_00000000_00000000)
            XCTAssertEqual(uint8_max << 4, 0b00001111_11110000)
            XCTAssertEqual(uint8_max >> 4, 0b00001111)
            
            let uint8_65280: T = 0b11111111_00000000
            XCTAssertEqual(uint8_65280 >> 8, 0b00000000_11111111)
            XCTAssertEqual(uint8_65280 >> 4, 0b00001111_11110000)
            
            let uint8_16711680: T = 0b11111111_00000000_00000000
            XCTAssertEqual(uint8_16711680 >> (UInt8.bitWidth / 2), 0b00001111_11110000_00000000)
            XCTAssertEqual(uint8_16711680 >> (UInt8.bitWidth * 2), 0b11111111)
            XCTAssertEqual(uint8_16711680 >> (UInt8.bitWidth * 3), 0b00000000)
            
            let uint8_zero: T = T(UInt8.zero)
            XCTAssertEqual(uint8_zero << 4, 0)
            XCTAssertEqual(uint8_zero >> 4, 0)
            XCTAssertEqual(uint8_zero << -4, 0)
            XCTAssertEqual(uint8_zero >> -4, 0)
            
            XCTAssertEqual(uint8_max << 0, uint8_max)
            XCTAssertEqual(uint8_max >> 0, uint8_max)
            XCTAssertEqual(uint8_max << -0, uint8_max)
            XCTAssertEqual(uint8_max >> -0, uint8_max)
            
            XCTAssertEqual(uint8_max >> -4, 4080)
            XCTAssertEqual(uint8_max << -4, 15)
            
            let uint8_128: T = 128              // (0b00000000_10000000)
            XCTAssertEqual(uint8_128 << 1, 256) // (0b00000001_00000000)
            
            
            let uint8_x: T = 5                    //     (0b00000101)
            let uint8_y: T = 14                   //     (0b00001110)
            XCTAssertEqual(uint8_x & uint8_y, 4)  // AND (0b00000100)
            XCTAssertEqual(uint8_x | uint8_y, 15) // OR  (0b00001111)
            XCTAssertEqual(uint8_x ^ uint8_y, 11) // XOR (0b00001011)
            XCTAssertNotEqual(uint8_x, ~uint8_x)  // NOT (-b--------)
            XCTAssertEqual(30 << 2, 120)          // LHS (0b01111000)
            XCTAssertEqual(30 >> 2, 7)            // RHS (0b00000111)
            XCTAssertEqual(30 >> 11, 0)           // ROS (0b00000000)
            
            /// `T` grows and cannot `Overshifted` to the left.
            XCTAssertEqual(30 << 11, 61440)  // LGS (0b00000011_11000000_000000000)
            
            /// Negative Shifts
            XCTAssertEqual(30 << -2, 7)
            XCTAssertEqual(30 >> -2, 120)
            
            /// Mutation
            var uint8_a: T = uint8_x                        //     (0b00000101)
            var uint8_b: T = uint8_y                        //     (0b00001110)
            uint8_a &= uint8_b; XCTAssertEqual(uint8_a, 4)  // AND (0b00000100)
            uint8_a |= uint8_b; XCTAssertEqual(uint8_a, 14) // OR  (0b00001110)
            uint8_a ^= uint8_b; XCTAssertEqual(uint8_a, 0)  // XOR (0b00000000)
            uint8_b <<= 2; XCTAssertEqual(uint8_b, 56)      // LHS (0b01111000)
            uint8_b >>= 3; XCTAssertEqual(uint8_b, 7)       // RHS (0b00001111)
            uint8_b <<= 14; XCTAssertEqual(uint8_b, 114688) // LGS (0b00000001_11000000_000000000)
            uint8_b >>= 17; XCTAssertEqual(uint8_b, 0)      // ROS (0b00000000)
            
            /// Negative Shifts
            var uint8_c: T = uint8_x
            uint8_c >>= -4; XCTAssertEqual(uint8_c, 80)
            uint8_c <<= -2; XCTAssertEqual(uint8_c, 20)
            
            /// Growing PrecisionUInt
            var uint8_nn3: T = T(UInt64.max)
            var uint8_nn4 = uint8_y
            uint8_nn3 &= uint8_nn4; XCTAssertEqual(uint8_nn3, 14)
            uint8_nn3 |= uint8_nn4; XCTAssertEqual(uint8_nn3, 14)
            uint8_nn3 <<= uint8_nn4; XCTAssertEqual(uint8_nn3, 229376)
            uint8_nn4 >>= uint8_nn3; XCTAssertEqual(uint8_nn4, 0)
            // FIXME: - change tests to StaticBigInt once Swift 5.8 lands
            uint8_nn3 ^= uint8_nn4; XCTAssertEqual(uint8_nn3, 229376)
        }
        
        for type in types { bitwiseOperations(type) }
    }
    
    // MARK: - BinaryInteger Conformance
    func testSigned() {
        func signed<T: _APSI_TestProtocol>(_ typed: T.Type) {
            XCTAssertEqual(T.isSigned, true)
        }
        
        for type in types { signed(type) }
    }
    
    func testMultiple() {
        func multiple<T: _APSI_TestProtocol>(_ typed: T.Type) {
            let x: T = 21
            XCTAssertTrue(x.isMultiple(of: 7), "\(T.ArchitectureWidth.self)")
            XCTAssertFalse(x.isMultiple(of: 8), "\(T.ArchitectureWidth.self)")
            
            let y = -x
            XCTAssertTrue(y.isMultiple(of: 7), "\(T.ArchitectureWidth.self)")
            XCTAssertTrue(y.isMultiple(of: -7), "\(T.ArchitectureWidth.self)")
            XCTAssertFalse(y.isMultiple(of: 8), "\(T.ArchitectureWidth.self)")
        }
        
        for type in types { multiple(type) }
    }
    
    /// Strideable
    func testStrideable() {
        func strideable<T: _APSI_TestProtocol>(_ typed: T.Type) {
            let x: T = 21
            XCTAssertEqual(x.advanced(by: 3), 24, "\(T.ArchitectureWidth.self)")
            XCTAssertEqual(x.distance(to: 24), 3, "\(T.ArchitectureWidth.self)")
            
            let y = -x
            XCTAssertEqual(y.advanced(by: 3), -18, "\(T.ArchitectureWidth.self)")
            XCTAssertEqual(y.advanced(by: -3), -24, "\(T.ArchitectureWidth.self)")
            XCTAssertEqual(y.advanced(by: 24), 3, "\(T.ArchitectureWidth.self)")
            XCTAssertEqual(y.distance(to: -24), -3, "\(T.ArchitectureWidth.self)")
        }
        
        for type in types { strideable(type) }
    }
    
    func testCodable() {
        func various<T: _APSI_TestProtocol, U: _APSI_TestProtocol>(_ expected: T, typed: U.Type, data: Data) {
            let decoder = JSONDecoder()
            let decoded = try! decoder.decode(typed, from: data)
            XCTAssertEqual(expected.description, decoded.description)
        }
        
        func codable<T: _APSI_TestProtocol>(_ typed: T.Type) {
            let pn1 = T(T.ArchitectureWidth.max)
            let pn2 = pn1 + 1
            XCTAssertEqual(pn2._mantissa._storage.count, 2)
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.sortedKeys]
            let data = try! encoder.encode(pn2)
            for type in types { various(pn2, typed: type, data: data) }
            
            let nn1 = -T(T.ArchitectureWidth.max)
            let nn2 = nn1 - 1
            XCTAssertEqual(nn2._mantissa._storage.count, 2)
            XCTAssertEqual(nn2 - nn1, -1)
            XCTAssertEqual(nn2 % nn1, -1)

            let encoder2 = JSONEncoder()
            encoder2.outputFormatting = [.sortedKeys]
            let data2 = try! encoder2.encode(nn2)
            for type in types { various(nn2, typed: type, data: data2) }
            
            XCTAssertNotEqual(data, data2)
            XCTAssertEqual(pn2 * -1, nn2)
            XCTAssertEqual(nn2 * -1, pn2)
        }
        
        for type in types { codable(type) }
    }
}
