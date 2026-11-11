import KernelCore
import os
import ProviderLogo
import LumiLoggingKit
import SwiftUI

/// Smart Light Logo 插件（共享包 LumiPluginLogos）。
///
/// 贡献智能灯光主题 Logo（提供动画灯泡图标）。精简内核（SuperPlugin）没有
/// `logoItems` 声明式贡献点，因此本插件在 `onBoot(kernel:)` 中主动解析
/// `LogoProviding`，用追加语义注册自己的 `LogoItem`；消费方（如菜单栏图标）
/// 按 `order` 优先级取用。
///
/// 宿主差异（插件 id、启用策略等）通过 ``LogoSmartLightConfiguration`` 注入；
/// 默认值保持 Lumi 的历史行为。
@MainActor
public final class LogoSmartLightPlugin: SuperPlugin, SuperLog {
    nonisolated public static let emoji = "💡"
    nonisolated static let verbose = false

    public let configuration: LogoSmartLightConfiguration
    nonisolated let logger: Logger

    public let id: String
    public let order: Int
    public let metadata: PluginMetadata

    public init(configuration: LogoSmartLightConfiguration = LogoSmartLightConfiguration()) {
        self.configuration = configuration
        self.logger = Logger(subsystem: configuration.loggerSubsystem, category: "plugin.logo-smart-light")
        self.id = configuration.pluginID
        self.order = configuration.order
        self.metadata = PluginMetadata(
            id: configuration.pluginID,
            name: pluginLocalization.string("Smart Light Logo"),
            description: pluginLocalization.string("Contributes the smart-light themed logo with an animated bulb icon."),
            category: .design,
            stage: .stable,
            policy: configuration.policy
        )
    }

    public func onBoot(kernel: KernelCoreContainer) throws {
        guard let logo = kernel.resolveProvider((any LogoProviding).self) else {
            logger.info("\(Self.t)LogoProviding not configured, skipping Smart Light Logo registration")
            return
        }

        logo.registerLogoItem(
            LogoItem(
                id: id,
                order: order,
                makeView: { scene in
                    SmartLightLogoView(scene: scene)
                }
            )
        )
        if Self.verbose {
            logger.info("\(Self.t)Registered Smart Light Logo item: \(self.id)")
        }
    }

    public func onShutdown(kernel: KernelCoreContainer) throws {
        kernel.resolveProvider((any LogoProviding).self)?.unregisterLogoItem(id: id)
        if Self.verbose {
            logger.info("\(Self.t)Unregistered Smart Light Logo item: \(self.id)")
        }
    }
}