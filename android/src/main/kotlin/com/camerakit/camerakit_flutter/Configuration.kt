package com.camerakit.camerakit_flutter

//
//  Configuration.kt
//  com.camerakit.camerakit_flutter
//
//  Copyright © 2023 DevCrew I/O
//
class Configuration private constructor(
    val cameraKitApiToken: String,
    val groupIds: List<String>,
    val lensId: String,
    var isHideCloseButton: Boolean
) {

    companion object {
        private var instance: Configuration? = null

        fun getInstance() = instance
            ?: throw IllegalStateException("please set configuration with Configuration.createFromMap(...) method")


        fun createFromMap(arguments: Map<String, Any>): Configuration {
            instance = Configuration(
                groupIds = arguments["groupIds"] as? List<String> ?: emptyList(),
                cameraKitApiToken = arguments["token"] as? String ?: "",
                lensId = arguments["lensId"] as? String ?: "",
                isHideCloseButton = arguments["isHideCloseButton"] as? Boolean ?: false,
            )
            return instance!!
        }
    }

}

