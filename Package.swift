import PackageDescription

let package = Package(
    name: "Validation",
    dependencies: [
        .Package(url: "https://github.com/vapor/debugging.git", majorVersion: 1),
        .Package(url: "https://github.com/vapor/node.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/json.git", majorVersion: 2),
    ]
)
