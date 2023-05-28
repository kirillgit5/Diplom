// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UI",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "UI",
            targets: ["UI"]
        )
    ],
    dependencies: [
        .package(
            name: "PopupView",
            url: "https://github.com/exyte/PopupView.git",
            from: "1.3.0"
        ),
        .package(
            name: "Introspect",
            url: "https://github.com/siteline/SwiftUI-Introspect.git",
            from: "0.1.4"
        ),
        .package(
            name: "Core",
            path: "../Core"
        ),
        .package(
            name: "PhoneNumberKit",
            url: "https://github.com/marmelroy/PhoneNumberKit.git",
            from: "3.3.4"
        ),
        .package(
            name: "ComposableArchitecture",
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            from: "0.49.2"
        )
    ],
    targets: [
        .target(
            name: "UI",
            dependencies: [
                "PopupView",
                "Introspect",
                "PhoneNumberKit",
                "Core",
                "ComposableArchitecture"
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
