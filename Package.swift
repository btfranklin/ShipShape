// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ShipShape",
    platforms: [
        .macOS(.v11), .iOS(.v13),
    ],
    products: [
        .library(
            name: "ShipShape",
            targets: ["ShipShape"]),
    ],
    dependencies: [
        .package(url: "https://github.com/btfranklin/ControlledChaos",
                 from: "1.1.1"),
        .package(name: "Aesthete",
                 url: "https://github.com/btfranklin/Aesthete.git",
                 from: "1.5.1"),
        .package(name: "Greebler",
                 url: "https://github.com/btfranklin/Greebler.git",
                 from: "0.7.0"),
    ],
    targets: [
        .target(
            name: "ShipShape",
            dependencies: [.product(name: "ControlledChaos",
                                    package: "ControlledChaos"),
                           .product(name: "Aesthete",
                                    package: "Aesthete"),
                           .product(name: "Greebler",
                                    package: "Greebler")
            ]),
        .testTarget(
            name: "ShipShapeTests",
            dependencies: ["ShipShape"]),
    ]
)
