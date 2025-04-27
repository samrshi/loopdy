// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Parser",
    platforms: [.iOS(.v18), .macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Parser",
            targets: ["Parser"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.1.4"),
        .package(url: "https://github.com/AudioKit/AudioKit.git", from: "5.6.5"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Parser",
            dependencies: [
                .product(name: "DequeModule", package: "swift-collections"),
                .product(name: "AudioKit", package: "AudioKit"),
            ],
            resources: [
                .copy("Sounds/Samples"),
            ]
        ),
        .testTarget(name: "ParserTests", dependencies: ["Parser"]),
    ]
)
