// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Services",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Services",
            targets: ["Services"]
        )
    ],
    dependencies: [
        .package(
            name: "KeychainAccess",
            url: "https://github.com/kishikawakatsumi/KeychainAccess.git",
            from: "4.2.2"
        ),
        .package(
            name: "Core",
            path: "../Core"
        ),
        .package(
            name: "PhoneNumberKit",
            url: "https://github.com/marmelroy/PhoneNumberKit.git",
            from: "3.5.5"
        ),
        .package(
            name: "ComposableArchitecture",
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            from: "0.49.2"
        )
    ],
    targets: [
        .target(
            name: "Services",
            dependencies: [
                "KeychainAccess",
                "Core",
                "ComposableArchitecture"
            ]
        )
    ]
)
