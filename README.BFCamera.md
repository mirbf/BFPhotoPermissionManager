# BFCameraPermissionManager

Camera permission request + "Go to Settings" guide alert helper.

- Swift implementation
- Objective-C callable
- Guide alert localization: English + zh-Hans

## Requirements

- iOS 13.0+

## Host App (Info.plist)

You must provide the usage description in your host app:

- `NSCameraUsageDescription`

This Pod does not (and should not) ship Info.plist permission strings.

## Installation (local path)

```ruby
pod 'BFCameraPermissionManager', :path => '/Users/bigger/Desktop/Pod/BFCameraPermissionManager'
```

## Usage

### Objective-C

```objc
@import BFCameraPermissionManager;

[BFCameraPermissionManager requestAuthorizationFromViewController:self completion:^(BOOL authorized) {
    // ...
}];
```

### Swift

```swift
import BFCameraPermissionManager

BFCameraPermissionManager.requestAuthorization(fromViewController: self) { authorized in
    // ...
}
```

## Guide Alert Customization

You can provide a custom title/message:

- `showPermissionGuideAlertFromViewController:title:message:completion:`

If title/message are nil, the Pod uses its built-in localized strings.
