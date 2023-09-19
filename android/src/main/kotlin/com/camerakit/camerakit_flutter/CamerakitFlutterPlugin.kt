package com.camerakit.camerakit_flutter

import androidx.annotation.NonNull
import com.snap.camerakit.support.app.CameraActivity
import android.content.Intent
import android.app.Activity
import android.content.Context
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
class CamerakitFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {


  private val CAMERAKIT_GROUP_ID = "5f2ae409-6d1d-41f4-8e27-f96c9a09c0e5" //TODO fill group id here
  private val CAMERAKIT_API_TOKEN = "eyJhbGciOiJIUzI1NiIsImtpZCI6IkNhbnZhc1MyU0hNQUNQcm9kIiwidHlwIjoiSldUIn0.eyJhdWQiOiJjYW52YXMtY2FudmFzYXBpIiwiaXNzIjoiY2FudmFzLXMyc3Rva2VuIiwibmJmIjoxNjM5MDcyNTQyLCJzdWIiOiJjYzc3M2JjMy05MDc4LTQxYTYtOWFlMS02MTEwZjYwZjI0ZTN-U1RBR0lOR344N2MxOThmYi04M2NiLTRlN2UtYjc5ZC1mOTg5NDNlYmI5NjQifQ.1tIfB8jtIelFjEEZiFgDzFmAZHBJb49OI0ZnYbFOkE0" //TODO fill api token here
  private val CHANNEL = "camerakit_flutter"

  private lateinit var _result: MethodChannel.Result
  private lateinit var _methodChannel: MethodChannel
  private lateinit var context: Context
  private lateinit var activity: Activity

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel


  companion object {

    // Method-channel names
    const val OPEN_CAMERAKIT = "open_snap_camerakit"

  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

    if (call.method == OPEN_CAMERAKIT) {
      activity.startActivityForResult(CameraActivity.Capture.createIntent(context, CameraActivity.Configuration.WithLenses(
        cameraKitApiToken = CAMERAKIT_API_TOKEN,
        lensGroupIds = arrayOf(CAMERAKIT_GROUP_ID)
      )), 200)
    } else {
      result.notImplemented()
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
