//
//  Constants.kt
//  com.camerakit.camerakit_flutter
//
//  Copyright © 2023 DevCrew I/O
//

package com.camerakit.camerakit_flutter

object MethodChannels{
    const val OPEN_CAMERA_KIT = "openSnapCameraKit"
    const val SET_CAMERA_KIT_CREDENTIALS = "setCameraKitCredentials"
    const val GET_GROUP_LENSES = "getGroupLenses"

}

object InvokeMethods{
    const val receivedLenses = "receivedLenses"
    const val cameraKitResults = "cameraKitResults"

}