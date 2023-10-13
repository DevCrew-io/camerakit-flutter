//
//  StringExtenstions.kt
//  com.camerakit.camerakit_flutter
//
//  Copyright © 2023 DevCrew I/O
//


import java.util.Locale

fun String.getFileType(): String {
    val fileExtension = substringAfterLast(".")
    return when (fileExtension.lowercase(Locale.ROOT)) {
        "jpg", "jpeg", "png", "gif", "bmp" -> "image"
        "mp4", "avi", "mov", "mkv" -> "video"
        else -> "unknown"
    }
}