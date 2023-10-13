import Foundation

protocol InvokeMethods {}

enum InputMethods: InvokeMethods {
    static let GET_GROUP_LENSES = "getGroupLenses"
    static let OPEN_CAMERA_KIT = "openSnapCameraKit"
    static let SET_CAMERA_KIT_CREDENTIALS = "setCameraKitCredentials"
}

enum OutputMethods: InvokeMethods {
    static let RECEIVED_LENSES = "receivedLenses"
    static let CAMERA_KIT_RESULTS = "cameraKitResults"
}
