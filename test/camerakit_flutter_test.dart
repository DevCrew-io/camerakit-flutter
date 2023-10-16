import 'package:camerakit_flutter/configuration_camerakit.dart';
import 'package:camerakit_flutter/lens_model.dart';
import 'package:flutter/src/services/platform_channel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camerakit_flutter/camerakit_flutter.dart';
import 'package:camerakit_flutter/camerakit_flutter_platform_interface.dart';
import 'package:camerakit_flutter/camerakit_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCamerakitFlutterPlatform
    with MockPlatformInterfaceMixin
    implements CamerakitFlutterPlatform {

  @override
  Future<void> getGroupLenses(List<String> groupIds) {
    // TODO: implement getGroupLenses
    throw UnimplementedError();
  }

  @override
  MethodChannel getMethodChannel() {
    // TODO: implement getMethodChannel
    throw UnimplementedError();
  }

  @override
  Future<String?> openCameraKit() {
    // TODO: implement openCameraKit
    throw UnimplementedError();
  }

  @override
  setCameraKitCredentials(Configuration configuration) {
    // TODO: implement setCameraKitCredentials
    throw UnimplementedError();
  }
}

void main() {
  final CamerakitFlutterPlatform initialPlatform =
      CamerakitFlutterPlatform.instance;

  test('$MethodChannelCamerakitFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCamerakitFlutter>());
  });

  test('getPlatformVersion', () async {
    CameraKitFlutterImpl camerakitFlutterPlugin = CameraKitFlutterImpl(
        cameraKitFlutterEvents: MockTwoCameraKitFlutterEvents());
    MockCamerakitFlutterPlatform fakePlatform = MockCamerakitFlutterPlatform();
    CamerakitFlutterPlatform.instance = fakePlatform;

    expect(await camerakitFlutterPlugin.openCameraKit(), '42');
  });
}

// Define a mock event handler for testing purposes.
class MockTwoCameraKitFlutterEvents extends CameraKitFlutterEvents {
  @override
  void onCameraKitResult(Map result) {
    // TODO: implement onCameraKitResult
  }

  @override
  void receivedLenses(List<Lens> lensList) {
    // TODO: implement receivedLenses
  }
}
