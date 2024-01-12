package com.camerakit.camerakit_flutter

//
//  Configuration.kt
//  com.camerakit.camerakit_flutter
//
//  Copyright © 2023 DevCrew I/O
//
class Configuration private constructor(
    val apiToken: String,
    var isHideCloseButton: Boolean
) {

    companion object {
        private var instance: Configuration? = null

        fun getInstance() = instance
            ?: throw IllegalStateException("please set configuration with Configuration.createFromMap(...) method")


        fun createFromMap(arguments: Map<String, Any>): Configuration {
            instance = Configuration(
                apiToken = arguments["token"] as? String ?: "",
                isHideCloseButton = false,
            )
            return instance!!
        }
    }

}

