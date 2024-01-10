//
//  configuration_camerakit.dart
//  com.camerakit.camerakit_flutter
//
//  Copyright © 2023 DevCrew I/O
//

/// Configuration is a simple data class used to store configuration settings for CameraKit.
class Configuration {
  final String token;
  final List<String> groupIds;
  bool isHideCloseButton;
  String lensId;

  Configuration({required this.token, required this.groupIds, this.isHideCloseButton = false, this.lensId = ""});
}
