// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZCJSON",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ZCJSON",
            targets: ["ZCJSON"]),
    ],
    dependencies: [
        // 添加第三方库的依赖
        .package(url: "https://github.com/ZClee128/ZCMacro.git", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ZCJSON",
            dependencies: ["ZCMacro"],
            path: "ZCJSON",
            sources: ["Classes"],
            swiftSettings: [
                .enableExperimentalFeature("Macros")
            ]
        ),
        .testTarget(
            name: "ZCJSONTests",
            dependencies: ["ZCJSON"],
            path: "Example/Tests"),
    ]
)
