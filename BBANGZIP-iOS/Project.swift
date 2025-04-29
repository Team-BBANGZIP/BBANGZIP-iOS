import ProjectDescription

let project = Project(
    name: "BBANGZIP-iOS",
    targets: [
        .target(
            name: "BBANGZIP-iOS",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.BBANGZIP-iOS",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["BBANGZIP-iOS/Sources/**"],
            resources: ["BBANGZIP-iOS/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "BBANGZIP-iOSTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.BBANGZIP-iOSTests",
            infoPlist: .default,
            sources: ["BBANGZIP-iOS/Tests/**"],
            resources: [],
            dependencies: [.target(name: "BBANGZIP-iOS")]
        ),
    ]
)
