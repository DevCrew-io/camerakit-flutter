import 'package:camerakit_flutter/camerakit_flutter.dart';
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
    final version =
        await methodChannel.invokeMethod<String>('openSnapCameraKit');
    return version;
  }

  @override
  setCameraKitCredentials(Configuration configuration) {
    final Map<String, dynamic> arguments = {
      'appId': configuration.appId,
      'groupId': configuration.groupId,
      'token': configuration.token
    };
    methodChannel.invokeMethod<String>('setCameraKitCredentials', arguments);
  }
}
