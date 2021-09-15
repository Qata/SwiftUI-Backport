// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUI-Backport",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11),
        .tvOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Backport",
            targets: ["SwiftUI-Backport"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(name: "Introspect", url: "https://github.com/siteline/SwiftUI-Introspect.git", from: "0.1.3"),
        .package(url: "https://github.com/apple/swift-algorithms", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftUI-Backport",
            dependencies: [
                "Introspect",
                .product(name: "Algorithms", package: "swift-algorithms"),
            ]),
        .testTarget(
            name: "SwiftUI-BackportTests",
            dependencies: [
                "SwiftUI-Backport",
                .product(name: "Algorithms", package: "swift-algorithms"),
            ]),
    ]
)
