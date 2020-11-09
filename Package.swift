// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SDOSFLEX",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "SDOSFLEX",
            targets: ["SDOSFLEX"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDOSLabs/FLEX.git", .upToNextMajor(from: "4.3.0"))
    ],
    targets: [
        .target(
            name: "SDOSFLEX",
            dependencies: [
                "FLEX"
            ],
            path: "src"
        )
    ]
)
