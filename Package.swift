import PackageDescription

let package = Package(
    name: "Validation",
    dependencies: [
        .Package(url: "https://github.com/vapor/debugging.git", majorVersion: 1),
    ]
)
