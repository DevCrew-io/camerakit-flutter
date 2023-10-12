import 'package:camerakit_flutter/lens_model.dart';

import 'camerakit_flutter_platform_interface.dart';
import 'package:flutter/services.dart';

import 'configuration_camerakit.dart';

class CameraKitFlutterImpl {
  final CameraKitFlutterEvents cameraKitFlutterEvents;
  CameraKitFlutterImpl({required this.cameraKitFlutterEvents}) {

    CamerakitFlutterPlatform.instance.getMethodChannel().setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'cameraKitResults':
          cameraKitFlutterEvents.onCameraKitResult(call.arguments);
      break;
        case 'receiveLenses':
          cameraKitFlutterEvents.receiveLenses(call.arguments);
          break;

      }
    });
  }
  Future<String?> openCameraKit() {
    return CamerakitFlutterPlatform.instance.openCameraKit();
  }

  /// Method to set Snap CameraKit credentials.

  setCredentials(Configuration configuration) {
    CamerakitFlutterPlatform.instance
        .setCameraKitCredentials(configuration);
  }

  Future<void> getGroupLenses(){
    return CamerakitFlutterPlatform.instance.getGroupLenses();
  }

}

/// Abstract class defining event callbacks related to CameraKit.

abstract class CameraKitFlutterEvents {

  void onCameraKitResult(Map<dynamic,dynamic> result);

  void receiveLenses(String jsonString);

}
