# QiitaKitForSample

This is a simple Qiita API client and UI to use in sample projects.

## Requirements

- Swift 4 or above
- iOS 9.0 or above
- carthage 0.26.2
- [SwiftIconFont](https://github.com/0x73/SwiftIconFont)
- [Nuke](https://github.com/kean/Nuke)

## Installation

You can install via Carthage.

```ruby: Cartfile
github "masashi-sutou/QiitaKitForSample"
```
## Usage

- If you don't have a Qiita Personal Access Toke, please generate your toke from below url.
- https://qiita.com/settings/applications

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    // Qiita Authorization
    ApiSession.shared.token = "Your Qiita Personal Access Token"

    return true
}
```
