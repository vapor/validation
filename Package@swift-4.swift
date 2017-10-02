// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Validation",
    products: [
        .library(name: "Validation", targets: ["Validation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/debugging.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(name: "Validation", dependencies: ["Debugging"]),
        .testTarget(name: "ValidationTests", dependencies: ["Validation"]),
    ]
)
