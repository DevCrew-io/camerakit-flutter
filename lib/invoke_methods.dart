//
//  invoke_methods.dart
//  com.camerakit.camerakit_flutter
//
//  Copyright © 2023 DevCrew I/O
//

abstract class InvokeMethods {}

class OutputMethods implements InvokeMethods {
  static const openSnapCameraKit = "openSnapCameraKit";
  static const openSingleLens = "openSingleLens";
  static const getGroupLenses = "getGroupLenses";
}

class InputMethods implements InvokeMethods {
  static const cameraKitResults = "cameraKitResults";
  static const receivedLenses = "receivedLenses";
}
