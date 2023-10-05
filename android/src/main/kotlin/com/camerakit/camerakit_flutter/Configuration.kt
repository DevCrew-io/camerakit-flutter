class Configuration private constructor(
    val appId: String,
    val cameraKitApiToken: String,
    val groupIds: List<String>,
    val lensId: String
) {

    companion object {
        private var instance: Configuration? = null

        fun getInstance() = instance
            ?: throw IllegalStateException("please set configuration with Configuration.createFromMap(...) method")


        fun createFromMap(arguments: Map<String, Any>): Configuration {
            instance = Configuration(
                appId = arguments["appId"] as? String
                    ?: throw IllegalArgumentException("appId cannot be empty or null"),
                groupIds = arguments["groupIds"] as? List<String> ?: emptyList(),
                cameraKitApiToken = arguments["token"] as? String ?: "",
                lensId = arguments["lensId"] as? String ?: "",
            )
            return instance!!
        }
    }

}

