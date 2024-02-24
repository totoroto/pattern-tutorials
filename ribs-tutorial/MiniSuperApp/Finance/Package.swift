// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Finance",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "AddPaymentMethod",
            targets: ["AddPaymentMethod"]),
        .library(
            name: "FinanceEntity",
            targets: ["FinanceEntity"]),
        .library(
            name: "FinanceRepository",
            targets: ["FinanceRepository"])
    ],
    dependencies: [
        .package(name: "ModernRIBs", url: "https://github.com/DevYeom/ModernRIBs", .exact("1.0.1"))
    ],
    targets: [
        .target(
            name: "AddPaymentMethod",
            dependencies: ["ModernRIBs",
                           "FinanceEntity"
                          ]),
        .target(
            name: "FinanceEntity",
            dependencies: []),
        .target(
            name: "FinanceRepository",
            dependencies: ["FinanceEntity"])
    ]
)
