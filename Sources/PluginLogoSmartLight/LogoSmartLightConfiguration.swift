import KernelCore

/// `LogoSmartLightPlugin` 的宿主品牌配置。
///
/// 默认值保持 Lumi 的历史行为；插件 id 关系用户保存的启用状态，不可随意变更。
public struct LogoSmartLightConfiguration: Sendable {
    public var pluginID: String
    public var order: Int
    public var loggerSubsystem: String
    public var policy: PluginEnablePolicy

    public init(
        pluginID: String = "com.lumi.plugin.logo-smart-light",
        order: Int = 200,
        loggerSubsystem: String = "com.coffic.lumi",
        policy: PluginEnablePolicy = .required
    ) {
        self.pluginID = pluginID
        self.order = order
        self.loggerSubsystem = loggerSubsystem
        self.policy = policy
    }
}