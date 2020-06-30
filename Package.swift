// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "POSIX",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "POSIX", targets: ["POSIX"])
    ],
    dependencies: [
        .package(url: "git@github.com:vmanot/Swallow", .branch("master"))
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
    ],
    swiftLanguageVersions: [
        .version("5.1")
    ]
)
