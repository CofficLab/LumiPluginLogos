import KernelCore

/// `PluginLogoBolt` 的宿主品牌配置。
///
/// 默认值保持 Wakey 的历史行为；插件 id 关系用户保存的启用状态，不可随意变更。
public struct LogoBoltConfiguration: Sendable {
    public var pluginID: String
    public var order: Int
    public var loggerSubsystem: String
    public var policy: PluginEnablePolicy

    public init(
        pluginID: String = "LogoBoltPlugin",
        order: Int = 0,
        loggerSubsystem: String = "com.coffic.wakey.plugin.logo.bolt",
        policy: PluginEnablePolicy = .alwaysOn
    ) {
        self.pluginID = pluginID
        self.order = order
        self.loggerSubsystem = loggerSubsystem
        self.policy = policy
    }
}