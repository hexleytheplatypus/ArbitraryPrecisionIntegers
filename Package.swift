// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ArbitraryPrecisionIntegers",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ArbitraryPrecisionIntegers",
            targets: ["ArbitraryPrecisionIntegers"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/hexleytheplatypus/Memoize.git", from: "0.0.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ArbitraryPrecisionIntegers",
            dependencies: ["Memoize"]),
        .testTarget(
            name: "ArbitraryPrecisionIntegersTests",
            dependencies: ["ArbitraryPrecisionIntegers"]),
    ]
)
