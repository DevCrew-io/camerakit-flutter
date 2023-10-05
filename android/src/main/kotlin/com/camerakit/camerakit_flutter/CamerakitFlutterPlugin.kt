package com.camerakit.camerakit_flutter

import androidx.annotation.NonNull
import com.snap.camerakit.support.app.CameraActivity
import android.content.Intent
import android.app.Activity
import android.content.ContentValues.TAG
import android.content.Context
import android.util.Log
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.PluginRegistry
import androidx.core.net.toFile
import com.camerakit.camerakit_flutter.MethodChannels
import getFileType
import java.util.Locale

/** CamerakitFlutterPlugin */
class CamerakitFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {

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

    private val cameraKitRequestCode = 200;
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            MethodChannels.SET_CAMERA_KIT_CREDENTIALS -> {
                val arguments: Map<String, Any>? = call.arguments()
                if (arguments != null) {
                    Configuration.createFromMap(arguments)
                }

            }

            MethodChannels.OPEN_CAMERA_KIT -> {
               val configuration = Configuration.getInstance()
                val intent = if (configuration.lensId.isNotEmpty()) {
                    CameraActivity.Capture.createIntent(
                        context, CameraActivity.Configuration.WithLens(
                            cameraKitApiToken = configuration.cameraKitApiToken,
                            lensId = configuration.lensId,
                            lensGroupId = configuration.groupIds[0],
                        )
                    )
                } else {
                    CameraActivity.Capture.createIntent(
                        context, CameraActivity.Configuration.WithLenses(
                            cameraKitApiToken = configuration.cameraKitApiToken,
                            lensGroupIds = configuration.groupIds.toSet()

                        )
                    )
                }
                activity.startActivityForResult(intent, 200)
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
        binding.addActivityResultListener(this);
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

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == cameraKitRequestCode && resultCode == Activity.RESULT_OK && data != null) {
            val type = data.data?.toFile()?.absolutePath?.let {
                it.getFileType()
            }
            val theMap = mapOf(
                "path" to data.data?.toFile()?.absolutePath,
                "type" to type
            )

            channel.invokeMethod("cameraKitResults", theMap);
        } else {
            Log.d(TAG, "onActivityResult: No data received from the camera");
        }
        return false

    }
}
