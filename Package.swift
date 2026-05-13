// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Homing",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "Homing", targets: ["Homing"])
    ],
    targets: [
        .target(
            name: "Homing",
            path: "Homing",
            exclude: ["App/HomingApp.swift"]
        ),
        .testTarget(
            name: "HomingTests",
            dependencies: ["Homing"],
            path: "HomingTests"
        )
    ]
)
