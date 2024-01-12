//
//  camerakit_flutter_method_channel.dart
//  com.camerakit.camerakit_flutter
//
//  Copyright © 2023 DevCrew I/O
//

import 'package:camerakit_flutter/invoke_methods.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'camerakit_flutter_platform_interface.dart';

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
  Future<String?> openCameraKit(
      {required List<String> groupIds, bool isHideCloseButton = false}) {
    final Map<String, dynamic> arguments = {
      'groupIds': groupIds,
      'isHideCloseButton': isHideCloseButton
    };
    // Invoke the native method to open the CameraKit.
    return methodChannel.invokeMethod<String>(
        OutputMethods.openSnapCameraKit, arguments);
  }

  @override
  Future<String?> openCameraKitWithSingleLens(
      {required String lensId,
      required String groupId,
      bool isHideCloseButton = false}) {
    final Map<String, dynamic> arguments = {
      'lensId': lensId,
      'groupId': groupId,
      'isHideCloseButton': isHideCloseButton
    };
    // Invoke the native method to open the CameraKit with single lens.
    return methodChannel.invokeMethod<String>(
        OutputMethods.openSingleLens, arguments);
  }

  @override
  Future<String?>  setCameraKitCredentials({required String apiToken}) {
    final Map<String, dynamic> arguments = {'token': apiToken};
    return methodChannel.invokeMethod<String>(
        OutputMethods.setCameraKitCredentials, arguments);
  }

  @override
  Future<String?> getGroupLenses({required List<String> groupIds}) {
    final Map<String, dynamic> arguments = {'groupIds': groupIds};
    // Invoke the native method to retrieve group lenses from the CameraKit.
    return methodChannel.invokeMethod<String>(OutputMethods.getGroupLenses, arguments);
  }
}
