import java.util.Locale

fun getFileType(filePath: String): String {
    val fileExtension = filePath.substringAfterLast(".")
    return when (fileExtension.lowercase(Locale.ROOT)) {
        "jpg", "jpeg", "png", "gif", "bmp" -> "image"
        "mp4", "avi", "mov", "mkv" -> "video"
        else -> "unknown"
    }
}