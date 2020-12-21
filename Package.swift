// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "OnChange13",
    platforms: [.iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)],
    products: [
        .library(name: "OnChange13", targets: ["OnChange13"])
    ],
    targets: [
        .target(name: "OnChange13"),
        .testTarget(name: "OnChange13Tests", dependencies: ["OnChange13"])
    ]
)
