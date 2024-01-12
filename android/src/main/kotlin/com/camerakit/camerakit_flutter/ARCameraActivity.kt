package com.camerakit.camerakit_flutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.widget.ImageButton
import androidx.activity.result.contract.ActivityResultContract
import com.snap.camerakit.support.app.CameraActivity

open class ARCameraActivity : CameraActivity() {

    lateinit var closeBtn: ImageButton
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val configuration = com.camerakit.camerakit_flutter.Configuration.getInstance()

        closeBtn = findViewById(R.id.close_btn)

        if (configuration.isHideCloseButton) {
            closeBtn.visibility = View.GONE
        } else {
            closeBtn.visibility = View.VISIBLE
        }

        closeBtn.setOnClickListener {
            finish()
        }
    }

    companion object {

        @JvmStatic
        fun intentForCaptureWith(context: Context, configuration: Configuration): Intent {
            return intentFor(context, configuration).apply {
                action = when (configuration) {
                    is Configuration.WithLenses -> {
                        ACTION_CAPTURE_WITH_LENSES
                    }

                    is Configuration.WithLens -> {
                        ACTION_CAPTURE_WITH_LENS
                    }
                }
            }
        }

        @JvmStatic
        fun intentForPlayWith(context: Context, configuration: Configuration): Intent {
            return intentFor(context, configuration).apply {
                action = when (configuration) {
                    is Configuration.WithLenses -> {
                        ACTION_PLAY_WITH_LENSES
                    }

                    is Configuration.WithLens -> {
                        ACTION_PLAY_WITH_LENS
                    }
                }
            }
        }

        @JvmStatic
        fun intentFor(context: Context, configuration: Configuration): Intent {
            return Intent(context, ARCameraActivity::class.java).apply {
                putExtra(EXTRA_CAMERAKIT_API_TOKEN, configuration.cameraKitApiToken)
                putExtra(EXTRA_CAMERA_FACING_FRONT, configuration.cameraFacingFront)
                putExtra(EXTRA_CAMERA_FACING_FLIP_ENABLED, configuration.cameraFacingFlipEnabled)
                putExtra(EXTRA_CAMERA_FACING_BASED_ON_LENS, configuration.cameraFacingBasedOnLens)
                putExtra(EXTRA_CAMERA_FLASH_CONFIGURATION, configuration.cameraFlashConfiguration.toBundle(extras))
                putExtra(
                    EXTRA_CAMERA_ADJUSTMENTS_CONFIGURATION,
                    configuration.cameraAdjustmentsConfiguration.toBundle(extras)
                )
                putExtra(EXTRA_CAMERA_FOCUS_ENABLED, configuration.cameraFocusEnabled)
                putExtra(EXTRA_CAMERA_ZOOM_ENABLED, configuration.cameraZoomEnabled)
                when (configuration) {
                    is Configuration.WithLenses -> {
                        putExtra(EXTRA_LENS_GROUP_IDS, configuration.lensGroupIds.toTypedArray())
                        putExtra(EXTRA_APPLY_LENS_ID, configuration.applyLensById)
                        putExtra(EXTRA_PREFETCH_LENS_ID_PATTERN, configuration.prefetchLensByIdPattern)
                        putExtra(EXTRA_DISABLE_LENSES_CAROUSEL_IDLE, configuration.disableIdleState)
                    }

                    is Configuration.WithLens -> {
                        putExtra(EXTRA_LENS_GROUP_IDS, arrayOf(configuration.lensGroupId))
                        val launchData = BundleLaunchDataBuilder().apply(configuration.withLaunchData).toBundle()
                        if (!launchData.isEmpty) putExtra(EXTRA_LENS_LAUNCH_DATA, launchData)
                        putExtra(EXTRA_APPLY_LENS_ID, configuration.lensId)
                        putExtra(EXTRA_DISABLE_LENSES_CAROUSEL, !configuration.displayLensIcon)
                    }
                }
            }
        }
    }

    /**
     * Defines a contract to start a capture flow in the [CameraActivity] with custom parameters expressed as the
     * [CameraActivity.Configuration] and to receive results in the form of the [CameraActivity.Capture.Result] using
     * the [androidx.activity.result.ActivityResultCaller.registerForActivityResult] method.
     */
    object Capture : ActivityResultContract<Configuration, Capture.Result>() {

        /**
         * Defines all the possible capture result states that a [CameraActivity] can produce.
         * A [Result] can be obtained from the [CameraActivity] which was started via the
         * [androidx.activity.result.ActivityResultCaller.registerForActivityResult] method that accepts the [Capture]
         * contract.
         */
        sealed class Result {

            /**
             * Indicates a successful capture flow with a result media [type] saved to a [uri].
             */
            sealed class Success(open val uri: Uri, open val type: String) : Result() {

                /**
                 * Successful capture of a video media [type], typically an mp4, saved to a [uri].
                 */
                data class Video(override val uri: Uri, override val type: String) : Success(uri, type)

                /**
                 * Successful capture of an image media [type], typically a jpeg, saved to a [uri].
                 */
                data class Image(override val uri: Uri, override val type: String) : Success(uri, type)
            }

            /**
             * Indicates a failure which occurred during the use of a [CameraActivity].
             */
            data class Failure(val exception: Exception) : Result()

            /**
             * Indicates a cancelled capture flow - either due to a user abandoning a [CameraActivity] or other causes
             * such as missing or incomplete arguments passed when starting a [CameraActivity].
             */
            object Cancelled : Result()
        }

        override fun createIntent(context: Context, configuration: Configuration): Intent {
            return intentForCaptureWith(context, configuration)
        }

        override fun parseResult(resultCode: Int, intent: Intent?): Result {
            return if (intent != null) {
                if (resultCode == Activity.RESULT_OK) {
                    val uri = intent.data
                    val type = intent.type
                    if (uri != null && type != null) {
                        when {
                            type.startsWith("image/") -> {
                                Result.Success.Image(uri, type)
                            }

                            type.startsWith("video/") -> {
                                Result.Success.Video(uri, type)
                            }

                            else -> {
                                Result.Cancelled
                            }
                        }
                    } else {
                        Result.Cancelled
                    }
                } else if (resultCode == Activity.RESULT_CANCELED) {
                    Result.Cancelled
                } else if (resultCode == RESULT_CODE_FAILURE) {
                    val exception = intent.getSerializableExtra(EXTRA_EXCEPTION) as? Exception
                    if (exception != null) {
                        Result.Failure(exception)
                    } else {
                        Result.Cancelled
                    }
                } else {
                    Result.Cancelled
                }
            } else {
                Result.Cancelled
            }
        }
    }

    /**
     * Defines a contract to start a play session in the [CameraActivity] with custom parameters expressed as the
     * [CameraActivity.Configuration] and to receive results in the form of the [CameraActivity.Play.Result] using
     * the [androidx.activity.result.ActivityResultCaller.registerForActivityResult] method.
     */
    object Play : ActivityResultContract<Configuration, Play.Result>() {

        /**
         * Defines all the possible play result states that a [CameraActivity] can produce.
         * A [Result] can be obtained from the [CameraActivity] which was started via the
         * [androidx.activity.result.ActivityResultCaller.registerForActivityResult] method that accepts the [Play]
         * contract.
         */
        sealed class Result {

            /**
             * Indicates a completed play session. This typically happens when a user navigates back.
             */
            object Completed : Result()

            /**
             * Indicates a failure which occurred during the use of a [CameraActivity].
             */
            data class Failure(val exception: Exception) : Result()
        }

        override fun createIntent(context: Context, configuration: Configuration): Intent {
            return intentForPlayWith(context, configuration)
        }

        override fun parseResult(resultCode: Int, intent: Intent?): Result {
            return if (intent != null) {
                if (resultCode == Activity.RESULT_OK) {
                    Result.Completed
                } else if (resultCode == Activity.RESULT_CANCELED) {
                    Result.Completed
                } else if (resultCode == RESULT_CODE_FAILURE) {
                    val exception = intent.getSerializableExtra(EXTRA_EXCEPTION) as? Exception
                    if (exception != null) {
                        Result.Failure(exception)
                    } else {
                        Result.Completed
                    }
                } else {
                    Result.Completed
                }
            } else {
                Result.Completed
            }
        }
    }
}