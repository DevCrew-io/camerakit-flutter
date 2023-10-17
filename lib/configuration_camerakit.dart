//
//  configuration_camerakit.dart
//  com.camerakit.camerakit_flutter
//
//  Copyright © 2023 DevCrew I/O
//

/// Configuration is a simple data class used to store configuration settings for CameraKit.
class Configuration {
  final List<String> groupIds;
  final String token;
  final String lensId;

  Configuration(this.groupIds, this.token, this.lensId);
}
