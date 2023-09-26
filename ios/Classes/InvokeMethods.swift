import Foundation

protocol InvokeMethods {}

class InputMethods: InvokeMethods {
    static let OPEN_CAMERA_KIT = "openSnapCameraKit"
    static let SET_CAMERA_KIT_CREDENTIALS = "setCameraKitCredentials"
}

class OutputMethods: InvokeMethods {
    static let CAMERA_KIT_RESULTS = "cameraKitResults"
}
