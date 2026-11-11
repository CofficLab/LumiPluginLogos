// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "LumiPluginLogos",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: "PluginLogoManager", targets: ["PluginLogoManager"]),
        .library(name: "PluginLogoCoffic", targets: ["PluginLogoCoffic"]),
        .library(name: "PluginLogoSmartLight", targets: ["PluginLogoSmartLight"]),
        .library(name: "PluginLogoBolt", targets: ["PluginLogoBolt"]),
    ],
    dependencies: [
        .package(url: "https://github.com/CofficLab/LumiKernel.git", from: "1.1.0"),
        .package(url: "https://github.com/CofficLab/LumiProviders.git", from: "1.22.0"),
        .package(url: "https://github.com/CofficLab/LumiLogging.git", from: "1.0.1"),
        .package(url: "https://github.com/CofficLab/LumiLocalization.git", from: "1.0.1"),
        .package(url: "https://github.com/CofficLab/LumiUI.git", from: "1.13.1"),
    ],
    targets: [
        .target(
            name: "PluginLogoManager",
            dependencies: [
                .product(name: "KernelCore", package: "LumiKernel"),
                .product(name: "ProviderLogo", package: "LumiProviders"),
                .product(name: "ProviderDocsView", package: "LumiProviders"),
                .product(name: "LumiLoggingKit", package: "LumiLogging"),
                .product(name: "LumiLocalizationKit", package: "LumiLocalization"),
                .product(name: "LumiUI", package: "LumiUI"),
            ],
            path: "Sources/PluginLogoManager",
            resources: [.process("../../Resources/PluginLogoManager/Localizable.xcstrings")]
        ),
        .target(
            name: "PluginLogoCoffic",
            dependencies: [
                .product(name: "KernelCore", package: "LumiKernel"),
                .product(name: "ProviderLogo", package: "LumiProviders"),
                .product(name: "ProviderDocsView", package: "LumiProviders"),
                .product(name: "LumiLoggingKit", package: "LumiLogging"),
                .product(name: "LumiLocalizationKit", package: "LumiLocalization"),
                .product(name: "LumiUI", package: "LumiUI"),
            ],
            path: "Sources/PluginLogoCoffic",
            resources: [.process("../../Resources/PluginLogoCoffic/Localizable.xcstrings")]
        ),
        .target(
            name: "PluginLogoSmartLight",
            dependencies: [
                .product(name: "KernelCore", package: "LumiKernel"),
                .product(name: "ProviderLogo", package: "LumiProviders"),
                .product(name: "LumiLoggingKit", package: "LumiLogging"),
                .product(name: "LumiLocalizationKit", package: "LumiLocalization"),
            ],
            path: "Sources/PluginLogoSmartLight",
            resources: [.process("../../Resources/PluginLogoSmartLight/Localizable.xcstrings")]
        ),
        .target(
            name: "PluginLogoBolt",
            dependencies: [
                .product(name: "KernelCore", package: "LumiKernel"),
                .product(name: "ProviderLogo", package: "LumiProviders"),
            ],
            path: "Sources/PluginLogoBolt",
            resources: [.process("../../Resources/PluginLogoBolt/Logo.xcstrings")]
        ),
        .testTarget(
            name: "PluginLogoManagerTests",
            dependencies: [
                "PluginLogoManager",
                .product(name: "KernelCore", package: "LumiKernel"),
                .product(name: "ProviderLogo", package: "LumiProviders"),
                .product(name: "ProviderDocsView", package: "LumiProviders"),
            ],
            path: "Tests/PluginLogoManagerTests"
        ),
        .testTarget(
            name: "PluginLogoCofficTests",
            dependencies: [
                "PluginLogoCoffic",
                .product(name: "KernelCore", package: "LumiKernel"),
                .product(name: "ProviderLogo", package: "LumiProviders"),
                .product(name: "ProviderDocsView", package: "LumiProviders"),
            ],
            path: "Tests/PluginLogoCofficTests"
        ),
        .testTarget(
            name: "PluginLogoSmartLightTests",
            dependencies: [
                "PluginLogoSmartLight",
                .product(name: "KernelCore", package: "LumiKernel"),
                .product(name: "ProviderLogo", package: "LumiProviders"),
            ],
            path: "Tests/PluginLogoSmartLightTests"
        ),
        .testTarget(
            name: "PluginLogoBoltTests",
            dependencies: [
                "PluginLogoBolt",
                .product(name: "KernelCore", package: "LumiKernel"),
                .product(name: "ProviderLogo", package: "LumiProviders"),
            ],
            path: "Tests/PluginLogoBoltTests"
        ),
    ]
)