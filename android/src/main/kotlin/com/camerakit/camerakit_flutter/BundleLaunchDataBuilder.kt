package com.camerakit.camerakit_flutter

import android.os.Bundle
import com.snap.camerakit.lenses.LensesComponent
import com.snap.camerakit.lenses.invoke
import kotlin.collections.toIntArray

/**
 * An implementation of [LensesComponent.Lens.LaunchData.Builder] based on [Bundle] instead of [Map]
 */
internal class BundleLaunchDataBuilder(
    private val bundle: Bundle = Bundle()
) : LensesComponent.Lens.LaunchData.Builder {

    fun toBundle() = bundle

    override fun putNumber(key: String, value: Number) = apply {
        when (value) {
            is Byte -> bundle.putByte(key, value)
            is Short -> bundle.putShort(key, value)
            is Int -> bundle.putInt(key, value)
            is Long -> bundle.putLong(key, value)
            is Float -> bundle.putFloat(key, value)
            is Double -> bundle.putDouble(key, value)
        }
    }

    override fun putNumbers(key: String, vararg value: Number) = apply {
        if (value.isEmpty()) return@apply
        when (value[0]) {
            is Byte -> bundle.putByteArray(key, value.filterIsInstance<Byte>().toByteArray())
            is Short -> bundle.putShortArray(key, value.filterIsInstance<Short>().toShortArray())
            is Int -> bundle.putIntArray(key, value.filterIsInstance<Int>().toIntArray())
            is Long -> bundle.putLongArray(key, value.filterIsInstance<Long>().toLongArray())
            is Float -> bundle.putFloatArray(key, value.filterIsInstance<Float>().toFloatArray())
            is Double -> bundle.putDoubleArray(key, value.filterIsInstance<Double>().toDoubleArray())
        }
    }

    override fun putString(key: String, value: String) = apply {
        bundle.putString(key, value)
    }

    override fun putStrings(key: String, vararg value: String) = apply {
        bundle.putStringArray(key, value)
    }

    override fun build() = LensesComponent.Lens.LaunchData {
        bundle.keySet().forEach { key ->
            when (val value = bundle.get(key)) {
                is Number -> putNumber(key, value)
                is String -> putString(key, value)
                is Array<*> -> {
                    if (value.isNotEmpty()) {
                        when (value[0]) {
                            is Number -> putNumbers(key, *value.filterIsInstance<Number>().toTypedArray())
                            is String -> putStrings(key, *value.filterIsInstance<String>().toTypedArray())
                        }
                    }
                }
            }
        }
    }
}
