# BFPhotoPermissionManager

Photo Library permission request + "Go to Settings" guide alert helper.

- Swift implementation
- Objective-C callable
- Guide alert localization: English + zh-Hans

## Requirements

- iOS 13.0+

## Host App (Info.plist)

You must provide the usage description in your host app:

- `NSPhotoLibraryUsageDescription`

This Pod does not (and should not) ship Info.plist permission strings.

## Installation (GitHub)

```ruby
pod 'BFPhotoPermissionManager', :git => 'git@github.com:mirbf/BFPhotoPermissionManager.git', :tag => '0.1.0'
```

## Usage

### Objective-C

```objc
@import BFPhotoPermissionManager;

[BFPhotoPermissionManager requestAuthorizationFromViewController:self completion:^(BOOL authorized) {
    // ...
}];
```

### Swift

```swift
import BFPhotoPermissionManager

BFPhotoPermissionManager.requestAuthorization(fromViewController: self) { authorized in
    // ...
}
```

## Behavior

- Status `.notDetermined`: shows only the system prompt; if user denies, it does NOT show the guide alert in the same request.
- Later calls when status is `.denied/.restricted`: shows the guide alert.
- Status `.limited` is treated as authorized.

## Guide Alert Customization

You can provide a custom title/message:

- `showPermissionGuideAlertFromViewController:title:message:completion:`

If title/message are nil, the Pod uses its built-in localized strings.
