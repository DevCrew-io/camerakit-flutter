import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'camerakit_flutter_platform_interface.dart';

/// An implementation of [CamerakitFlutterPlatform] that uses method channels.
class MethodChannelCamerakitFlutter extends CamerakitFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('camerakit_flutter');

  @override
  Future<String?> openCameraKit() async {
    final version =
        await methodChannel.invokeMethod<String>('openSnapCameraKit');
    return version;
  }

  @override
  setCameraKitCredentials(String appId, String GroupId, String token) {
    methodChannel.invokeMethod<String>('setCameraKitCredentials');
    final Map<String, dynamic> arguments = {
      'appId': appId,
      'groupId': GroupId,
      'token': token
    };
    methodChannel.invokeMethod<String>('setCameraKitCredentials', arguments);
  }
}
