import 'camerakit_flutter_platform_interface.dart';

class CameraKitFlutterEventsImpl {
  CameraKitFlutterEventsImpl() {}
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

abstract class TwoCheckoutFlutterEvents {
  void onShowDialogue(String title, String detail);
}
