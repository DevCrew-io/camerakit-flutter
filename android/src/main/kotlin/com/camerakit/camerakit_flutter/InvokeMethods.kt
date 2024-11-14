//
//  InvokeMethods.kt
//  com.camerakit.camerakit_flutter
//
//  Copyright © 2023 DevCrew I/O
//

package com.camerakit.camerakit_flutter

interface InvokeMethods {}
object InputMethods: InvokeMethods {
    const val GET_GROUP_LENSES = "getGroupLenses"
    const val OPEN_CAMERA_KIT = "openSnapCameraKit"
    const val OPEN_SINGLE_LENS = "openSingleLens"

}

object OutputMethods: InvokeMethods {
    const val RECEIVED_LENSES = "receivedLenses"
    const val CAMERA_KIT_RESULTS = "cameraKitResults"

}