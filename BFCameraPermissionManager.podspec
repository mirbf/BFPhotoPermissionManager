Pod::Spec.new do |s|
  s.name             = 'BFCameraPermissionManager'
  s.version          = '0.1.0'
  s.summary          = 'Camera permission request + guide alert helper (Swift, ObjC-callable).'

  s.description      = <<-DESC
BFCameraPermissionManager provides a simple API to request camera permission and show a "Go to Settings" guide alert.

- Swift implementation; Objective-C callable
- Built-in English and Simplified Chinese (zh-Hans) localization for guide alert
- Host app must provide NSCameraUsageDescription in Info.plist
  DESC

  s.homepage         = 'https://github.com/mirbf/BFPhotoPermissionManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE.BFCamera' }
  s.author           = { 'mirbf' => 'mirbf@users.noreply.github.com' }
  s.source           = { :git => 'https://github.com/mirbf/BFPhotoPermissionManager.git', :tag => "camera-#{s.version}" }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.requires_arc = true

  s.source_files = 'BFCameraPermissionManager/Classes/**/*.{swift}'
  s.resource_bundles = {
    'BFCameraPermissionManager' => ['BFCameraPermissionManager/Resources/**/*']
  }

  s.frameworks = 'Foundation', 'UIKit', 'AVFoundation'
end
