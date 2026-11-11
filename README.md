# LumiPluginLogos

Shared logo plugins for the Lumi app family. One package owns every logo
contribution; each app assembles the logos it needs instead of maintaining
its own logo package.

## Products

| Product | Contents |
| --- | --- |
| `PluginLogoManager` | `LogoManager` (`LogoProviding` implementation) + `PluginLogoManager` assembly plugin |
| `PluginLogoCoffic` | Coffic coffee-cup logo (animated + monochrome status-bar variants) |
| `PluginLogoSmartLight` | Smart-light bulb logo (animated + monochrome status-bar variants) |
| `PluginLogoBolt` | Energy-bolt logo |

## Assembly

```swift
import PluginLogoManager
import PluginLogoCoffic
import PluginLogoSmartLight
import PluginLogoBolt

// Defaults preserve Lumi's historical behavior.
PluginLogoManager(),
LogoCofficPlugin(),
LogoSmartLightPlugin(),

// Other hosts inject their own branding. Plugin IDs must stay stable:
// user-saved plugin enablement state is keyed by ID.
PluginLogoManager(
    configuration: LogoManagerConfiguration(
        pluginID: "com.coffic.gitok.plugin.logo-manager",
        loggerSubsystem: "com.coffic.gitok.plugin.logo-manager",
        policy: .disabled,
        contributesAboutEntry: true,
        appDisplayName: "GitOK"
    )
),
LogoCofficPlugin(
    configuration: LogoCofficConfiguration(
        policy: .disabled,
        contributesAboutEntry: true,
        appDisplayName: "GitOK"
    )
),
PluginLogoBolt(), // Wakey defaults
```

`PluginLogoManager` boots at order 4 and replaces the pre-registered
`DefaultLogoProviding`, copying any existing contributions. Logo contributor
plugins register their `LogoItem` in `onBoot`; consumers pick the highest
`order` per scene.

## Requirements

- macOS 14+ / iOS 17+
- Swift 6 toolchain
- KernelCore (LumiKernel), ProviderLogo / ProviderDocsView (LumiProviders)