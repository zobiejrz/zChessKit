// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "zChessKit",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "zChessKit",
            targets: ["zChessKit"]),
        .executable(name: "zChessKit-cli", targets: ["zChessKit-cli"]),
    ],
    dependencies: [
        .package(url: "https://github.com/zobiejrz/zBitboard", from: "0.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "zChessKit",
            dependencies: ["zBitboard"]
        ),
        .executableTarget(
            name: "zChessKit-cli",
            dependencies: ["zChessKit", "zBitboard"]
        ),
        .testTarget(
            name: "zChessKitTests",
            dependencies: ["zChessKit"]
        ),
    ]
)
