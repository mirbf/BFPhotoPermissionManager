Pod::Spec.new do |s|
  s.name             = 'BFPhotoPermissionManager'
  s.version          = '0.1.0'
  s.summary          = 'Photo Library permission request + guide alert helper (Swift, ObjC-callable).'

  s.description      = <<-DESC
BFPhotoPermissionManager provides a simple API to request Photo Library permission and show a "Go to Settings" guide alert.

- Swift implementation; Objective-C callable
- Built-in English and Simplified Chinese (zh-Hans) localization for guide alert
- Host app must provide NSPhotoLibraryUsageDescription in Info.plist
  DESC

  s.homepage         = 'https://github.com/mirbf/BFPhotoPermissionManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mirbf' => 'mirbf@users.noreply.github.com' }
  s.source           = { :git => 'git@github.com:mirbf/BFPhotoPermissionManager.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.requires_arc = true

  s.source_files = 'BFPhotoPermissionManager/Classes/**/*.{swift}'
  s.resource_bundles = {
    'BFPhotoPermissionManager' => ['BFPhotoPermissionManager/Resources/**/*']
  }

  s.frameworks = 'Foundation', 'UIKit', 'Photos'
end
