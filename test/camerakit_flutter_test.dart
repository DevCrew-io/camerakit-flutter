import 'package:flutter_test/flutter_test.dart';
import 'package:camerakit_flutter/camerakit_flutter.dart';
import 'package:camerakit_flutter/camerakit_flutter_platform_interface.dart';
import 'package:camerakit_flutter/camerakit_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCamerakitFlutterPlatform
    with MockPlatformInterfaceMixin
    implements CamerakitFlutterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CamerakitFlutterPlatform initialPlatform =
      CamerakitFlutterPlatform.instance;

  test('$MethodChannelCamerakitFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCamerakitFlutter>());
  });

  test('getPlatformVersion', () async {
    CamerakitFlutter camerakitFlutterPlugin = CamerakitFlutter();
    MockCamerakitFlutterPlatform fakePlatform = MockCamerakitFlutterPlatform();
    CamerakitFlutterPlatform.instance = fakePlatform;

    expect(await camerakitFlutterPlugin.openCameraKit(), '42');
  });
}
