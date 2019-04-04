// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Progress",
    products: [
        .library(name: "Progress", targets: ["Progress"]),
    ],
    targets: [
        .target(name: "Progress", dependencies: [], path: "Sources"),
    ]
)
