import KernelCore
import os
import ProviderDocsView
import ProviderLogo
import LumiLoggingKit
import SwiftUI

/// Coffic Logo 插件（共享包 LumiPluginLogos）。
///
/// 贡献咖啡主题 Logo（提供动画咖啡杯图标）。精简内核（SuperPlugin）没有
/// `logoItems` 声明式贡献点，因此本插件在 `onBoot(kernel:)` 中主动解析
/// `LogoProviding`，用追加语义注册自己的 `LogoItem`；消费方（如菜单栏图标）
/// 按 `order` 优先级取用。
///
/// 宿主差异（插件 id、启用策略、是否贡献「关于」页）通过
/// ``LogoCofficConfiguration`` 注入；默认值保持 Lumi 的历史行为。
@MainActor
public final class LogoCofficPlugin: SuperPlugin, SuperLog {
    nonisolated public static let emoji = "☕️"
    nonisolated static let verbose = false

    public let configuration: LogoCofficConfiguration
    nonisolated let logger: Logger

    public let id: String
    public let order: Int
    public let metadata: PluginMetadata

    public init(configuration: LogoCofficConfiguration = LogoCofficConfiguration()) {
        self.configuration = configuration
        self.logger = Logger(subsystem: configuration.loggerSubsystem, category: "plugin.logo-coffic")
        self.id = configuration.pluginID
        self.order = configuration.order
        self.metadata = PluginMetadata(
            id: configuration.pluginID,
            name: "Coffic Logo",
            description: pluginLocalization.string("Contributes the Coffic coffee-themed logo with an animated coffee cup icon."),
            category: .design,
            stage: .stable,
            policy: configuration.policy
        )
    }

    public func onRegister(kernel: KernelCoreContainer) throws {
        guard configuration.contributesAboutEntry else { return }
        let appName = configuration.appDisplayName
        kernel.resolveProvider((any DocsViewProviding).self)?.addAbout(
            DocsEntry(id: id, name: metadata.name) {
                LogoCofficAboutView(appName: appName)
            }
        )
    }

    public func onUnregister(kernel: KernelCoreContainer) throws {
        guard configuration.contributesAboutEntry else { return }
        kernel.resolveProvider((any DocsViewProviding).self)?.removeEntries(id: id)
    }

    public func onBoot(kernel: KernelCoreContainer) throws {
        guard let logo = kernel.resolveProvider((any LogoProviding).self) else {
            logger.info("\(Self.t)LogoProviding not configured, skipping Coffic Logo registration")
            return
        }

        logo.registerLogoItem(
            LogoItem(
                id: id,
                order: order,
                makeView: { scene in
                    CofficLogoView(scene: scene)
                }
            )
        )
        if Self.verbose {
            logger.info("\(Self.t)Registered Coffic Logo item: \(self.id)")
        }
    }

    public func onShutdown(kernel: KernelCoreContainer) throws {
        kernel.resolveProvider((any LogoProviding).self)?.unregisterLogoItem(id: id)
        if Self.verbose {
            logger.info("\(Self.t)Unregistered Coffic Logo item: \(self.id)")
        }
    }
}