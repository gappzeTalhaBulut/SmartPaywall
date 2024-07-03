# SmartPaywall

SmartPaywall, uygulamanızda ödeme duvarlarını (paywall) hızlı ve kolay bir şekilde yönetmenizi sağlayan bir Swift Package Manager (SPM) kütüphanesidir. Bu kütüphane, getPaywall servisine istek göndererek paywall görünümlerini ayağa kaldırmayı sağlar.

## Kurulum

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/gappzeTalhaBulut/SmartPaywall", from: "1.0.0")
]
```
## Kullanım

### Başlatma

```swift

import SmartPaywall

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private func initializePaywallService() {
        PaywallService.configure(
            productIDs: [
                "com.findvice.yearly",
                "com.findvice.weekly",
                "com.findvice.weekly3d",
                "com.findvice.monthly",
                "com.findvice.yearly3d"
            ])
        Task {
            await PaywallService.shared.initialize()
        }
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
