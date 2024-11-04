// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CustomHorizontalCollection",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CustomHorizontalCollection",
            targets: ["CustomHorizontalCollection"]
        ),
    ],
    targets: [
        .target(name: "CustomHorizontalCollection"),
        .testTarget(
            name: "CustomHorizontalCollectionTests",
            dependencies: ["CustomHorizontalCollection"]
        ),
    ]
)
