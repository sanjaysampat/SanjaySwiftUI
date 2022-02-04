// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

//  SanjaySwiftUIAppLibrary
//
//  Created by Sanjay Sampat on 19/01/22.
//  Copyright © 2022 Sanjay Sampat. All rights reserved.

import PackageDescription
import SwiftUI

let package = Package(
    name: "SanjaySwiftUIAppLibrary",
    // Required to add Localization to package.
    defaultLocalization: "en",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        //.library(name: "SanjaySwiftUIAppLibrary", targets: ["SanjaySwiftUIAppLibrary"]),
        .library(name: "SSPhotoEditor", targets: ["SSPhotoEditor"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        //.target(
        //    name: "SanjaySwiftUIAppLibrary",
        //    dependencies: []),
        .testTarget(
            name: "SanjaySwiftUIAppLibraryTests",
            dependencies: ["SSPhotoEditor"]),
        .target(name: "SSPhotoEditor", resources:[.process("Resources")]),
    ]
)
