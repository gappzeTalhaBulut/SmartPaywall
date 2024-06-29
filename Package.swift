// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SmartPaywall",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "SmartPaywall",
            targets: ["SmartPaywall"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sparrowcode/AlertKit", .upToNextMajor(from: "5.1.8")),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.0.0")),
        .package(url: "https://github.com/gappzeTalhaBulut/BaseFoundation", branch: "main")
    ],
    targets: [
        .target(
            name: "SmartPaywall",
            dependencies: [
                "AlertKit",
                "Kingfisher",
                "BaseFoundation"
            ],
            path: "Sources/SmartPaywall",
            resources: [
                .process("Font/Montserrat-Italic.ttf"),
                .process("Font/Montserrat.ttf"),
                .process("Font/SF-Pro.ttf")
            ]
        ),
        .testTarget(
            name: "SmartPaywallTests",
            dependencies: ["SmartPaywall"],
            path: "Tests/SmartPaywallTests"),
    ]
)

