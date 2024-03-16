// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Transport",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TransportHome",
            targets: ["TransportHome"]),
        .library(
            name: "TransportHomeImp",
            targets: ["TransportHomeImp"])
    ],
    dependencies: [
        .package(name: "ModernRIBs", url: "https://github.com/DevYeom/ModernRIBs", .exact("1.0.1")),
        .package(path: "../Finance")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "TransportHome",
            dependencies: ["ModernRIBs"]),
        .target(
            name: "TransportHomeImp",
            dependencies: ["ModernRIBs",
                           "TransportHome",
                           .product(name: "FinanceRepository", package: "Finance"),
                           .product(name: "Topup", package: "Finance")])
    ]
)
