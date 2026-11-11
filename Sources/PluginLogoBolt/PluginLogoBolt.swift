import KernelCore
import OSLog
import ProviderLogo
import SwiftUI

/// Logo 插件：能量闪电（共享包 LumiPluginLogos）。
///
/// 宿主差异（插件 id、启用策略等）通过 ``LogoBoltConfiguration`` 注入；
/// 默认值保持 Wakey 的历史行为。
@MainActor
public final class PluginLogoBolt: SuperPlugin {
    public let configuration: LogoBoltConfiguration
    nonisolated let logger: Logger

    public let id: String
    public let order: Int
    public let metadata: PluginMetadata

    public init(configuration: LogoBoltConfiguration = LogoBoltConfiguration()) {
        self.configuration = configuration
        self.logger = Logger(subsystem: configuration.loggerSubsystem, category: "LogoBolt")
        self.id = configuration.pluginID
        self.order = configuration.order
        self.metadata = PluginMetadata(
            id: configuration.pluginID,
            name: String(localized: "Bolt", table: "Logo", comment: "Name of the logo plugin"),
            description: String(localized: "Provide bolt logo variant", table: "Logo", comment: "Description of what the Logo plugin does"),
            policy: configuration.policy
        )
    }

    public func onBoot(kernel: KernelCoreContainer) throws {
        guard let logoProvider = kernel.resolveProvider(LogoProviding.self) else { return }
        logoProvider.registerLogoItem(LogoBolt.makeItem())
    }

    public func onShutdown(kernel: KernelCoreContainer) throws {
        kernel.resolveProvider(LogoProviding.self)?.unregisterLogoItem(id: LogoBolt.id)
    }
}