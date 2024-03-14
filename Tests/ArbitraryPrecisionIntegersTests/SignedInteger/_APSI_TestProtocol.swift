import XCTest
@testable import ArbitraryPrecisionIntegers

protocol _APSI_TestProtocol: SignedInteger, Codable, Strideable where Self.ArchitectureWidth.Magnitude == ArchitectureWidth {
    associatedtype ArchitectureWidth: FixedWidthInteger
    
    static var one: Self { get }
    static var two: Self { get }
    static var ten: Self { get }
    static var isSigned: Bool { get }
//    var _mantissa: _ArbitraryPrecisionUnsignedInteger<ArchitectureWidth> { get }
    var _mantissa: ArbitraryPrecisionUnsignedInteger { get }
    var isNegative: Bool { get }
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
    //    static func random() -> Self
    static func random(in range: ClosedRange<ArchitectureWidth>) -> Self
    init?(_ source: String, radix: Int)
    init(integerLiteral value: StaticBigInt)
}

extension _APSI_TestProtocol {
    init?(_ source: String) {
        self.init(source, radix: 10)
    }
}

extension ArbitraryPrecisionSignedInteger: _APSI_TestProtocol {}
