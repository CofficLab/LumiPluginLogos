import KernelCore
import ProviderDocsView
import ProviderLogo
import SwiftUI
import Testing
@testable import PluginLogoManager

/// `PluginLogoManager` 的装配接线覆盖：替换默认 Provider、保留旧贡献、
/// 宿主配置注入与「关于」页贡献。
@Suite("PluginLogoManager 接线")
@MainActor
struct PluginLogoManagerWiringTests {

    @Test("默认配置保持 Lumi 历史行为")
    func defaultConfigurationMatchesLumi() {
        let plugin = PluginLogoManager()
        #expect(plugin.id == "com.coffic.lumi.plugin.logo-manager")
        #expect(plugin.order == 4)
        #expect(plugin.metadata.policy == .alwaysOn)
    }

    @Test("宿主配置注入插件 id 与策略（GitOK 形态）")
    func gitOKConfiguration() {
        let plugin = PluginLogoManager(
            configuration: LogoManagerConfiguration(
                pluginID: "com.coffic.gitok.plugin.logo-manager",
                loggerSubsystem: "com.coffic.gitok.plugin.logo-manager",
                policy: .disabled,
                contributesAboutEntry: true,
                appDisplayName: "GitOK"
            )
        )
        #expect(plugin.id == "com.coffic.gitok.plugin.logo-manager")
        #expect(plugin.metadata.id == "com.coffic.gitok.plugin.logo-manager")
        #expect(plugin.metadata.policy == .disabled)
    }

    @Test("onBoot 替换默认 LogoProviding 并保留已有贡献与高亮状态")
    func bootReplacesDefaultProviderAndKeepsContributions() throws {
        let kernel = KernelCoreContainer()
        let old = DefaultLogoProviding()
        old.registerLogoItem(LogoItem(id: "existing", order: 120) { _ in EmptyView() })
        old.setLogoHighlighted(true)
        try kernel.registerProvider((any LogoProviding).self, old)

        let plugin = PluginLogoManager()
        try plugin.onBoot(kernel: kernel)

        let logo = try #require(kernel.resolveProvider((any LogoProviding).self))
        #expect(logo is LogoManager)
        #expect(logo.allLogoItems.map(\.id) == ["existing"])
        #expect(logo.isLogoHighlighted == true)
    }

    @Test("onBoot 无默认 Provider 时也能装配")
    func bootWithoutDefaultProvider() throws {
        let kernel = KernelCoreContainer()

        let plugin = PluginLogoManager()
        try plugin.onBoot(kernel: kernel)

        let logo = kernel.resolveProvider((any LogoProviding).self)
        #expect(logo is LogoManager)
        #expect(logo?.allLogoItems.isEmpty == true)
    }

    @Test("宿主注册的 Provider 在 onShutdown 后仍可解析（host 语义）")
    func hostProviderSurvivesShutdown() throws {
        let kernel = KernelCoreContainer()
        let plugin = PluginLogoManager()
        try plugin.onBoot(kernel: kernel)

        try plugin.onShutdown(kernel: kernel)

        #expect(kernel.resolveProvider((any LogoProviding).self) is LogoManager)
    }

    @Test("contributesAboutEntry 开启时挂载「关于」条目，关闭时不挂载")
    func aboutEntryFollowsConfiguration() throws {
        let kernel = KernelCoreContainer()
        let docs = DefaultDocsViewProviding()
        try kernel.registerProvider((any DocsViewProviding).self, docs)

        let enabled = PluginLogoManager(
            configuration: LogoManagerConfiguration(contributesAboutEntry: true)
        )
        try enabled.onRegister(kernel: kernel)
        #expect(docs.aboutEntries.contains { $0.id == enabled.id })
        let entry = try #require(docs.aboutEntries.first { $0.id == enabled.id })
        #expect(entry.makeView() is AnyView)
        try enabled.onUnregister(kernel: kernel)
        #expect(!docs.aboutEntries.contains { $0.id == enabled.id })

        let disabled = PluginLogoManager()
        try disabled.onRegister(kernel: kernel)
        #expect(docs.aboutEntries.isEmpty)
    }

    @Test("可经 kernel.start 启动并接管 LogoProviding")
    func startsViaKernel() throws {
        let kernel = KernelCoreContainer()
        try kernel.registerProvider((any LogoProviding).self, DefaultLogoProviding())

        let plugin = PluginLogoManager()
        try kernel.start(plugins: [plugin])

        #expect(kernel.isPluginRegistered(id: plugin.id))
        #expect(kernel.resolveProvider((any LogoProviding).self) is LogoManager)
    }
}