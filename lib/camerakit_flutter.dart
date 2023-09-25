import 'camerakit_flutter_platform_interface.dart';
import 'package:flutter/services.dart';

class CameraKitFlutterEventsImpl {
  final CameraKitFlutterEvents cameraKitFlutterEvents;
  CameraKitFlutterEventsImpl({required this.cameraKitFlutterEvents}) {

    CamerakitFlutterPlatform.instance.getMethodChannel().setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'cameraKitResults':
          cameraKitFlutterEvents.onCameraKitResult(call.arguments);
      break;

      }
    });
  }
  Future<String?> openCameraKit() {
    return CamerakitFlutterPlatform.instance.openCameraKit();
  }

  /// Method to set Snap CameraKit credentials.

  setTwoCheckoutCredentials(String appId, String GroupId, String token) {
    CamerakitFlutterPlatform.instance
        .setCameraKitCredentials(appId, GroupId, token);
  }
}

/// Abstract class defining event callbacks related to TwoCheckout.

abstract class CameraKitFlutterEvents {
  void onCameraKitResult(String result);
}
