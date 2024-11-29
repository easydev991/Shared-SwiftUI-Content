// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DeeplinkParser",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "DeeplinkParser",
            targets: ["DeeplinkParser"]
        ),
    ],
    targets: [
        .target(
            name: "DeeplinkParser"),
        .testTarget(
            name: "DeeplinkParserTests",
            dependencies: ["DeeplinkParser"]
        )
    ]
)
