// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Validation",
    products: [
        .library(name: "Validation", targets: ["Validation"]),
    ],
    dependencies: [
        // 🌎 Utility package containing tools for byte manipulation, Codable, OS APIs, and debugging.
        .package(url: "https://github.com/vapor/core.git", from: "3.0.0-rc.2"),
    ],
    targets: [
        // Validation
        .target(name: "Validation", dependencies: ["Core"]),
        .testTarget(name: "ValidationTests", dependencies: ["Validation"]),
    ]
)
