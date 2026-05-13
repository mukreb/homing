// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TeslaViewer",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "TeslaViewer", targets: ["TeslaViewer"])
    ],
    targets: [
        .target(
            name: "TeslaViewer",
            path: "TeslaViewer",
            exclude: ["App/TeslaViewerApp.swift", "Resources"]
        ),
        .testTarget(
            name: "TeslaViewerTests",
            dependencies: ["TeslaViewer"],
            path: "TeslaViewerTests"
        )
    ]
)
