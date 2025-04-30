// swift-tools-version: 6.0
@preconcurrency
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    productTypes: [
        "Alamofire": .framework,
        "KakaoOpenSDK": .framework,
        "Kingfisher": .framework,
        "CombineCocoa": .framework,
    ]
)
#endif

let kakaoVersion = "2.23.0"
let alamofireVersion = "5.10.2"
let kingfisherVersion = "8.1.3"
let cocoapodsVersion = "0.4.1"

let package = Package(
    name: "BBANGZIP",
    dependencies: [
        .package(url: "https://github.com/kakao/kakao-ios-sdk", .upToNextMajor(from: Version(kakaoVersion)!)),
        .package(url: "https://github.com/Alamofire/Alamofire", .upToNextMajor(from: Version(alamofireVersion)!)),
        .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: Version(kingfisherVersion)!)),
        .package(url: "https://github.com/CombineCommunity/CombineCocoa.git", .upToNextMajor(from: Version(cocoapodsVersion)!))
    ]
)
