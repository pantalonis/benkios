// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "StudyQuestApp",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .executable(name: "StudyQuestApp", targets: ["StudyQuestApp"])
    ],
    targets: [
        .executableTarget(
            name: "StudyQuestApp",
            path: "Sources/StudyQuestApp"
        ),
        .testTarget(
            name: "StudyQuestAppTests",
            dependencies: ["StudyQuestApp"],
            path: "Tests/StudyQuestAppTests"
        )
    ]
)
