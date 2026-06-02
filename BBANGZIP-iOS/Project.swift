import ProjectDescription
import ProjectDescriptionHelpers

let infoPlist: [String: Plist.Value] = [
    "CFBundleDisplayName": "제 과제 빵점",
    "CFBundleShortVersionString": "1.0.0",
    "CFBundleVersion": "2",
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen.storyboard",
    "UIApplicationSceneManifest": [
        "UIApplicationSupportsMultipleScenes": false,
        "UISceneConfigurations": [
            "UIWindowSceneSessionRoleApplication": [
                [
                    "UISceneConfigurationName": "Default Configuration"
                ],
            ]
        ]
    ],
    "CFBundleURLTypes": [
        [
            "CFBundleTypeRole": "Editor",
            "CFBundleURLSchemes": ["kakao$(KAKAO_NATIVE_APP_KEY)"]
        ],
    ],
    "LSApplicationQueriesSchemes": [
        "kakaokompassauth",
        "kakaolink",
        "kakao$(KAKAO_NATIVE_APP_KEY)"
    ],
    "KAKAO_NATIVE_APP_KEY": "$(KAKAO_NATIVE_APP_KEY)",
    "BASE_URL": "$(BASE_URL)",
    "ITSAppUsesNonExemptEncryption": false,
    "UIUserInterfaceStyle": "Light",
    "UISupportedInterfaceOrientations": [
        "UIInterfaceOrientationPortrait"
    ]
]

private let settings = Settings.settings(
    base: ["SWIFT_VERSION": "6.0"],
    configurations: [
        .debug(name: .debug, xcconfig:
                .relativeToRoot("BBANGZIP-iOS/Resources/Config/Secrets.xcconfig")),
        .release(name: .release, xcconfig: .relativeToRoot("BBANGZIP-iOS/Resources/Config/Secrets.xcconfig"))
    ])

private let moduleName = "BBANGZIP"

let project = Project.makeModule(
    name: moduleName,
    destinations: [.iPhone],
    product: .app,
    bundleId: "BBANGZIP-iOS.app",
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["BBANGZIP-iOS/Sources/**"],
    resources: ["BBANGZIP-iOS/Resources/**", "BBANGZIP-iOS/**/*.json"],
    dependencies: [
        .external(name: "Alamofire", condition: .none),
        .external(name: "KakaoSDKAuth", condition: .none),
        .external(name: "KakaoSDKCommon", condition: .none),
        .external(name: "KakaoSDKUser", condition: .none),
        .external(name: "Kingfisher", condition: .none),
        .external(name: "CombineCocoa", condition: .none),
        .external(name: "Lottie", condition: .none)
    ],
    settings: settings
)

let testTarget = Project.makeModule(
    name: "\(moduleName)Tests",
    destinations: [.iPhone, .iPad],
    product: .unitTests,
    bundleId: "\(moduleName)Tests",
    infoPlist: .default,
    sources: ["BBANGZIP-iOS/Tests/**"],
    resources: [],
    dependencies: [
        .target(name: moduleName)
    ]
)
