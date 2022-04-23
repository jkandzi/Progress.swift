// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Progress",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        .library(name: "Progress", targets: ["Progress"]),
    ],
    targets: [
        .target(name: "Progress", dependencies: [], path: "Sources"),
    ]
)
