// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Progress",
    products: [
        .library(name: "Progress", targets: ["Progress"]),
    ],
    targets: [
        .target(name: "Progress", dependencies: []),
        .testTarget(name: "ProgressTests", dependencies: ["Progress"])
    ]
)
