// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DatSci",
    platforms: [
      .macOS(.v10_15)
  ],
    products: [
        .library(name:"DatSci", targets:["DatSci"])
    ],

    dependencies: [
      .package(url: "https://github.com/IBM-Swift/Swift-Kuery", from: "3.0.1"),
      .package(url: "https://github.com/IBM-Swift/Swift-Kuery-PostgreSQL", from: "2.1.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DatSci",
            dependencies: ["SwiftKuery","SwiftKueryPostgreSQL"]),
        .testTarget(
            name: "DatSciTest",
            dependencies: ["DatSci"],
            path: "Tests"),
    ]
)
