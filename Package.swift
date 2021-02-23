// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "POSIX",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "POSIX", targets: ["POSIX"])
    ],
    dependencies: [
        .package(url: "https://github.com/vmanot/Swallow.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "POSIX",
            dependencies: ["Swallow"],
            path: "Sources",
            swiftSettings: [
                .unsafeFlags(["-Onone"])
            ]
        )
    ]
)
