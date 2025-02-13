# SmartPaywall

SmartPaywall, uygulamanızda ödeme duvarlarını (paywall) hızlı ve kolay bir şekilde yönetmenizi sağlayan bir Swift Package Manager (SPM) kütüphanesidir. Bu kütüphane, getPaywall servisine istek göndererek paywall görünümlerini ayağa kaldırmayı sağlar.

## Kurulum

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/gappzeTalhaBulut/SmartPaywall", from: "1.0.9")
]
```
## Kullanım

### Başlatma

```swift

import SmartPaywall

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

      private func initializePaywallService() async {
        await PaywallService.configure(
            unique: Config.UDID,
            bundle: Config.bundleIdentifier,
            country: LogHelper.deviceCountry,
            lang: LogHelper.deviceLang,
            version: AppConfig.version,
            isTest: AppConfig.isTest,
            serviceURL: "",
            serviceToken: "",
            fallbackProductIDs: [
                "com.record.yearly",
                "com.record.weekly",
                "com.record.weekly3d",
                "com.record.monthly",
                "com.record.yearly3d"
            ]
        )
        await PaywallService.shared.initialize()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializePaywallService()
        return true
    }
}
```
### SmartPaywallParameters' ı çağırın

Bu noktada ilgili uygulamanın serviceURL ve serviceToken 'ını girmeyi unutmayın. Bu işlemler Repository sınfıında yapılmaktadır.

```swift
  private func openPaywall(placementId: Int,
                             action: AppPaywallAction,
                             experimentName: String,
                             controller: UIViewController,
                             onCloseAction: (() -> ())? = nil,
                             onPurchaseSuccess: @escaping () -> (),
                             onRestoreSuccess: @escaping () -> ()) {
        var openPaywallId: Int?
        let parameters = SmartPaywallParameters(
            placementId: placementId,
            action: action.rawValue,
            bundle: Config.bundleIdentifier,
            uniqueId: Config.UDID,
            country: LogHelper.deviceCountry,
            language: LogHelper.deviceLang,
            paywallVersion: AppConfig.paywallVersion,
            version: AppConfig.version,
            isTest: AppConfig.isTest,
            serviceURL: AppConfig.smartPaywallServiceURL,
            serviceToken: AppConfig.smartPaywallToken
        )
```
