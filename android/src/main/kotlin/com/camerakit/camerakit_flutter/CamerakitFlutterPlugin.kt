package com.camerakit.camerakit_flutter

import androidx.annotation.NonNull
import com.snap.camerakit.support.app.CameraActivity
import android.content.Intent
import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import androidx.core.content.ContextCompat.startActivity


/** CamerakitFlutterPlugin */
class CamerakitFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private val CHANNEL = "camerakit_flutter"
    private lateinit var _result: MethodChannel.Result
    private lateinit var _methodChannel: MethodChannel
    private lateinit var context: Context
    private lateinit var activity: Activity

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel


    companion object {

        // Method-channel names
        const val OPEN_CAMERA_KIT = "openSnapCameraKit"
        const val SET_CAMERA_KIT_CREDENTIALS = "setCameraKitCredentials"

        //credentials for Camerakit

        var APP_ID = ""
        var GROUP_ID = ""
        var CAMERA_KIT_API_TOKEN = ""
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            SET_CAMERA_KIT_CREDENTIALS -> {
                Log.d("TAG", "onMethodCall: ${APP_ID}")
                val arguments: Map<String, Any>? = call.arguments()
                APP_ID = arguments?.get("appId") as String
                GROUP_ID = arguments["groupId"] as String
                CAMERA_KIT_API_TOKEN = arguments["token"] as String
            }

            OPEN_CAMERA_KIT -> {
                activity.startActivityForResult(
                    CameraActivity.Capture.createIntent(
                        context, CameraActivity.Configuration.WithLenses(
                            cameraKitApiToken = CAMERA_KIT_API_TOKEN,
                            lensGroupIds = arrayOf(GROUP_ID),
                                    cameraKitApplicationId = APP_ID
                        )
                    ), 200
                )
            }

            else -> {
                result.notImplemented()
            }
        }


    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }


    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        // binding.addActivityResultListener(this);
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }
}
