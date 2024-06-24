#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint camerakit_flutter.podspec` to validate before publishing.
#

Pod::Spec.new do |s|
  s.name             = 'camerakit_flutter'
  s.version          = '1.0.1'
  s.summary          = 'A camerakit plugin that provides developers with seamless integration and access to Snapchat\'s CameraKit features within their Flutter applications.'
  s.description      = <<-DESC
        An open-source SDK package for Flutter that provides developers with seamless integration and access to Snapchat CameraKit features within their Flutter applications. Flutter developers now can access set configuration from Flutter for both platforms (IOS and Android), you can open CameraKit , get media results (Images and Videos) and get list of lenses against group Ids.
                       DESC
  s.homepage         = 'https://pub.dev/packages/camerakit_flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'DevCrew I/O' => 'https://devcrew.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.dependency 'SCCameraKit', '~> 1.31.0'
  s.dependency 'SCCameraKitReferenceUI', '~> 1.31.0'

end
