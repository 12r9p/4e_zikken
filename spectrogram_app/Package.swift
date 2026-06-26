// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SpectrogramApp",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .executable(name: "SpectrogramApp", targets: ["SpectrogramApp"])
    ],
    targets: [
        .executableTarget(
            name: "SpectrogramApp",
            path: "Sources/SpectrogramApp"
        )
    ]
)
