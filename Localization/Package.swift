// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Localization",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Localization",
            targets: ["Localization"]
        )
    ],
    targets: [
        .target(
            name: "Localization",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
