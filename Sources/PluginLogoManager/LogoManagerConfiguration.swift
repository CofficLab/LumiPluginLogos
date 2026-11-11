import KernelCore

/// `PluginLogoManager` 的宿主品牌配置。
///
/// 默认值保持 Lumi 的历史行为；插件 id 关系用户保存的启用状态，
/// 各宿主必须沿用各自的历史 id（如 GitOK 的 `com.coffic.gitok.plugin.logo-manager`）。
public struct LogoManagerConfiguration: Sendable {
    public var pluginID: String
    public var loggerSubsystem: String
    public var policy: PluginEnablePolicy
    public var contributesAboutEntry: Bool
    public var appDisplayName: String

    public init(
        pluginID: String = "com.coffic.lumi.plugin.logo-manager",
        loggerSubsystem: String = "com.coffic.lumi.plugin.logo-manager",
        policy: PluginEnablePolicy = .alwaysOn,
        contributesAboutEntry: Bool = false,
        appDisplayName: String = "Lumi"
    ) {
        self.pluginID = pluginID
        self.loggerSubsystem = loggerSubsystem
        self.policy = policy
        self.contributesAboutEntry = contributesAboutEntry
        self.appDisplayName = appDisplayName
    }
}