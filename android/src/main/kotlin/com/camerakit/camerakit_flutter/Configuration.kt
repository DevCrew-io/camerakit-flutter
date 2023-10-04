package com.camerakit.camerakit_flutter

class Configuration  constructor(
    var appId: String = "",
    var cameraKitApiToken: String = "",
    var groupIds: List<String> = emptyList(),
    var lensId: String = "",
) {
    companion object {
        val shared = Configuration()
    }

    fun fromMap(arguments: Map<String, Any>) {
        appId = arguments["appId"] as? String ?: ""
        groupIds = arguments["groupIds"] as? List<String> ?: emptyList()
        cameraKitApiToken = arguments["token"] as? String ?: ""
        lensId = arguments["lensId"] as? String ?: ""
    }
}


