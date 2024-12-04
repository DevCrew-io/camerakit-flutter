package com.camerakit.camerakit_flutter

//
//  Configuration.kt
//  com.camerakit.camerakit_flutter
//
//  Copyright © 2023 DevCrew I/O
//
class Configuration private constructor(
    var channelName: String = "camerakit_flutter",
    var isHideCloseButton: Boolean = false
) {

    companion object {
        private var instance: Configuration? = null

        fun getInstance(): Configuration {
            if (instance == null) {
                instance = Configuration()
            }

            return instance!!
        }
    }

}

