import KernelCore

/// `LogoCofficPlugin` 的宿主品牌配置。
///
/// 共享 Logo 包不绑定具体 app：插件 id、启用策略、日志 subsystem 与
/// 「关于」页贡献都由装配方注入。默认值保持 Lumi 的历史行为，
/// 尤其是插件 id——用户保存的启用状态按 id 存储，不可随意变更。
public struct LogoCofficConfiguration: Sendable {
    public var pluginID: String
    public var order: Int
    public var loggerSubsystem: String
    public var policy: PluginEnablePolicy
    public var contributesAboutEntry: Bool
    public var appDisplayName: String

    public init(
        pluginID: String = "com.lumi.plugin.logo-coffic",
        order: Int = 100,
        loggerSubsystem: String = "com.coffic.lumi",
        policy: PluginEnablePolicy = .required,
        contributesAboutEntry: Bool = false,
        appDisplayName: String = "Lumi"
    ) {
        self.pluginID = pluginID
        self.order = order
        self.loggerSubsystem = loggerSubsystem
        self.policy = policy
        self.contributesAboutEntry = contributesAboutEntry
        self.appDisplayName = appDisplayName
    }
}