import Foundation

protocol InvokeMethods {}

enum InputMethods: InvokeMethods {
    static let GET_GROUP_LENSES = "getGroupLenses"
    static let OPEN_CAMERA_KIT = "openSnapCameraKit"
    static let OPEN_SINGLE_LENS = "openSingleLens"
}

enum OutputMethods: InvokeMethods {
    static let RECEIVED_LENSES = "receivedLenses"
    static let CAMERA_KIT_RESULTS = "cameraKitResults"
}
