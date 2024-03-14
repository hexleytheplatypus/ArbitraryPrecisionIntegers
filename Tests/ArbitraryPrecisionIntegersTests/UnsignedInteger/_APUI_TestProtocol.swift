import XCTest
@testable import ArbitraryPrecisionIntegers

protocol _APUI_TestProtocol: UnsignedInteger, Codable, ExpressibleByIntegerLiteral, Strideable where Self.Stride: SignedInteger {
    associatedtype ArchitectureWidth: FixedWidthInteger
    var _storage: [ArchitectureWidth] { get }
    
    static var one: Self { get }
    static var two: Self { get }
    static var ten: Self { get }
    static var isSigned: Bool { get }
    var isZero: Bool { get }
    var isNaturalNumber: Bool { get }
    var isWholeNumber: Bool { get }
    var isInteger: Bool { get }
    var isRational: Bool { get }
    var isRepeating: Bool { get }
    var isIrrational: Bool { get }
    var isRealNumber: Bool { get }
    var isComplexNumber: Bool { get }
    var description: String { get }
    var debugDescription: String { get }
    var binaryString: String { get}
    var decimalString: String { get }
    var hexString: String { get }
    var compactString: String { get }
    static func random(in range: ClosedRange<ArchitectureWidth>) -> Self
    init?(_ source: String, radix: Int)
    init(integerLiteral value: StaticBigInt)
    
    func quotientAndRemainder(dividingBy rhs: Self) -> (quotient: Self, remainder: Self)
    var isPrime: Bool { get }
    
    func greatestCommonDivisor(with other: Self) -> Self
    static func greatestCommonDivisor(_ lhs: Self, _ rhs: Self) -> Self
    func leastCommonMultiple(with other: Self) -> Self
    static func leastCommonMultiple(_ lhs: Self, _ rhs: Self) -> Self
}

extension _APUI_TestProtocol {
    init?(_ source: String) {
        self.init(source, radix: 10)
    }
}

extension ArbitraryPrecisionUnsignedInteger: _APUI_TestProtocol {}
