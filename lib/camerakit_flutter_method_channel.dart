//
//  camerakit_flutter_method_channel.dart
//  com.camerakit.camerakit_flutter
//
//  Copyright © 2023 DevCrew I/O
//

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'camerakit_flutter_platform_interface.dart';
import 'configuration_camerakit.dart';

/// An implementation of [CamerakitFlutterPlatform] that uses method channels.
class MethodChannelCamerakitFlutter extends CamerakitFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('camerakit_flutter');

  @override
  MethodChannel getMethodChannel() {
    return methodChannel;
  }

  @override
  Future<String?> openCameraKit() async {
    // Invoke the native method to open the CameraKit and return a version string.
    final version =
        await methodChannel.invokeMethod<String>('openSnapCameraKit');
    return version;
  }

  @override
  setCameraKitCredentials(Configuration configuration) {
    // Prepare a map with the necessary credentials and invoke the native method to set CameraKit credentials.
    final Map<String, dynamic> arguments = {
      'groupIds': configuration.groupIds,
      'token': configuration.token,
      'lensId': configuration.lensId
    };
    methodChannel.invokeMethod<String>('setCameraKitCredentials', arguments);
  }

  @override
  Future<void> getGroupLenses(List<String> groupIds) async {
    // Invoke the native method to retrieve group lenses from the CameraKit.
    await methodChannel.invokeMethod('getGroupLenses', groupIds);
  }
}
