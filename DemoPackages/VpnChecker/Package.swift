// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VpnChecker",
    platforms: [.iOS(.v14)], // работает и на iOS 12, но SPM предупреждает, что iOS 12 - самая старая версия из поддерживаемых
    products: [
        .library(name: "VpnChecker", targets: ["VpnChecker"]),
    ],
    targets: [
        .target(name: "VpnChecker"),
        .testTarget(name: "VpnCheckerTests", dependencies: ["VpnChecker"])
    ]
)
