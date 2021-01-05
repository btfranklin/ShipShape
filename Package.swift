// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ShipShape",
    products: [
        .library(
            name: "ShipShape",
            targets: ["ShipShape"]),
    ],
    dependencies: [
        .package(name: "Dunesailer Utilities", url: "https://github.com/dunesailer/Utilities.git", from: "1.0.0"),
        .package(name: "Aesthete", url: "https://github.com/dunesailer/Aesthete.git", from: "0.5.0"),
        .package(name: "Greebler", url: "https://github.com/dunesailer/Greebler.git", from: "0.2.1"),
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
