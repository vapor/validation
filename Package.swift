// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Validation",
    products: [
        .library(name: "Validation", targets: ["Validation"]),
    ],
    dependencies: [
        // Core extensions, type-aliases, and functions that facilitate common tasks.
        .package(url: "https://github.com/vapor/core.git", "3.0.0-beta.1"..<"3.0.0-beta.2"),
    ],
    targets: [
        // Validation
        .target(name: "Validation", dependencies: ["CodableKit"]),
        .testTarget(name: "ValidationTests", dependencies: ["Validation"]),
    ]
)
