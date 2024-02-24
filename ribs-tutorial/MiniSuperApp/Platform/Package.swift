// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Platform",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "CombineUtil",
            targets: ["CombineUtil"]),
        .library(
            name: "RIBsUtil",
            targets: ["RIBsUtil"])
    ],
    dependencies: [.package(url: "https://github.com/CombineCommunity/CombineExt", from: ("1.0.0")),
                   .package(name: "ModernRIBs", url: "https://github.com/DevYeom/ModernRIBs", .exact("1.0.1")),
    ],
    targets: [
        .target(
            name: "CombineUtil",
        dependencies: [
            "CombineExt"
        ]),
        .target(
            name: "RIBsUtil",
        dependencies: [
            "ModernRIBs"
        ])
    ]
)
