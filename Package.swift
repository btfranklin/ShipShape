// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ShipShape",
    platforms: [
        .macOS(.v10_15), .iOS(.v13),
    ],
    products: [
        .library(
            name: "ShipShape",
            targets: ["ShipShape"]),
    ],
    dependencies: [
        .package(name: "Dunesailer Utilities", url: "https://github.com/dunesailer/Utilities.git", from: "1.0.1"),
        .package(name: "Aesthete", url: "https://github.com/dunesailer/Aesthete.git", from: "0.8.0"),
        .package(name: "Greebler", url: "https://github.com/dunesailer/Greebler.git", from: "0.4.0"),
    ],
    targets: [
        .target(
            name: "ShipShape",
            dependencies: [.product(name: "DunesailerUtilities", package: "Dunesailer Utilities"),
                           .product(name: "Aesthete", package: "Aesthete"),
                           .product(name: "Greebler", package: "Greebler")
            ]),
        .testTarget(
            name: "ShipShapeTests",
            dependencies: ["ShipShape"]),
    ]
)
