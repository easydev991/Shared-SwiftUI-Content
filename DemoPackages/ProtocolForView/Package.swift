// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProtocolForView",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "PFVImplementation",
            targets: ["PFVImplementation"]
        ),
        .library(
            name: "PFVInterface",
            targets: ["PFVInterface"]
        ),
    ],
    targets: [
        .target(
            name: "PFVImplementation",
            dependencies: ["PFVInterface"]
        ),
        .target(name: "PFVInterface")
    ]
)
