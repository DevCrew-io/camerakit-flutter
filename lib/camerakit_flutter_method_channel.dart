import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'camerakit_flutter_platform_interface.dart';

/// An implementation of [CamerakitFlutterPlatform] that uses method channels.
class MethodChannelCamerakitFlutter extends CamerakitFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('camerakit_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('open_snap_camerakit');
    return version;
  }
}
