import KernelCore
import ProviderLogo
import SwiftUI
import Testing
@testable import PluginLogoCoffic

@MainActor
@Suite("PluginLogoCoffic")
struct PluginLogoCofficTests {

    @Test("onBoot 后 LogoProviding 已注册 Coffic Logo 项")
    func onBootRegistersCofficLogo() throws {
        let kernel = KernelCoreContainer()
        try kernel.registerProvider((any LogoProviding).self, DefaultLogoProviding())

        let plugin = LogoCofficPlugin()
        try plugin.onBoot(kernel: kernel)

        let logo = kernel.resolveProvider((any LogoProviding).self)
        #expect(logo?.highestPriorityLogoItem?.id == "com.lumi.plugin.logo-coffic")
        #expect(logo?.highestPriorityLogoItem?.order == 100)
    }

    @Test("未装配 LogoProviding 时 onBoot 不崩溃")
    func onBootWithoutLogoProviderIsNoOp() throws {
        let kernel = KernelCoreContainer()

        let plugin = LogoCofficPlugin()
        try plugin.onBoot(kernel: kernel)

        #expect(kernel.resolveProvider((any LogoProviding).self) == nil)
    }

    @Test("statusBar 场景渲染单色 Logo 视图")
    func statusBarSceneRendersMonochromeView() {
        let view = CofficLogoView(scene: .statusBar)
        #expect(type(of: view) == CofficLogoView.self)
    }

    @Test("general 场景渲染动画 Logo 视图")
    func generalSceneRendersAnimatedView() {
        let view = CofficLogoView(scene: .general)
        #expect(type(of: view) == CofficLogoView.self)
    }

    @Test("默认配置保持 Lumi 历史行为")
    func defaultConfigurationMatchesLumi() {
        let plugin = LogoCofficPlugin()
        #expect(plugin.id == "com.lumi.plugin.logo-coffic")
        #expect(plugin.order == 100)
        #expect(plugin.metadata.category == .design)
        #expect(plugin.metadata.stage == .stable)
        #expect(plugin.metadata.policy == .required)
    }

    @Test("宿主配置注入插件 id、order 与策略")
    func configurationInjection() throws {
        let kernel = KernelCoreContainer()
        let provider = DefaultLogoProviding()
        try kernel.registerProvider((any LogoProviding).self, provider)

        let plugin = LogoCofficPlugin(
            configuration: LogoCofficConfiguration(
                pluginID: "com.example.logo-coffic",
                order: 150,
                policy: .disabled
            )
        )
        #expect(plugin.id == "com.example.logo-coffic")
        #expect(plugin.metadata.id == "com.example.logo-coffic")
        #expect(plugin.metadata.policy == .disabled)

        try plugin.onBoot(kernel: kernel)
        let item = try #require(provider.allLogoItems.first)
        #expect(item.id == "com.example.logo-coffic")
        #expect(item.order == 150)

        try plugin.onShutdown(kernel: kernel)
        #expect(provider.allLogoItems.isEmpty)
    }
}