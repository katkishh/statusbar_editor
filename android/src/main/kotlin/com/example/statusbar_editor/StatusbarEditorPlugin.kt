package com.example.statusbar_editor

import android.app.Activity
import android.graphics.Color
import android.os.Build
import android.util.Log
import android.view.WindowInsets
import androidx.core.view.WindowCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** StatusbarEditorPlugin */
class StatusbarEditorPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private var activity: Activity? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "statusbar_editor")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall, result: Result
    ) {
        if (activity == null) return
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }

            "changeStatusBarColor" -> {
                val colorComponents: Map<*, Double> = call.arguments as Map<*, Double>
                setColor(colorComponents)
                result.success(null)
            }

            "changeStatusBarTheme" -> {
                val window = activity!!.window
                WindowCompat.getInsetsController(
                    window,
                    window.decorView
                ).isAppearanceLightStatusBars = call.argument<Boolean>("is_light")!!
                if (call.argument<Double?>("a") != null) {
                    val args: HashMap<*, Any> = call.arguments as HashMap<*, Any>
                    val colors: HashMap<String, Double> = hashMapOf()
                    args.forEach { it ->
                        if (it.key != "is_light") {
                            colors.put(it.key as String, it.value as Double)
                        }
                    }
                    setColor(colors)
                }
                result.success(null)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun setColor(colorComponents: Map<*, Double>) {
        val (a, r, g, b) = colorComponents.map { it -> it.value }

        val color = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Color.argb(a.toFloat(), r.toFloat(), g.toFloat(), b.toFloat())
        } else {
            Color.argb(
                (a * 255).toInt(),
                (r * 255).toInt(),
                (g * 255).toInt(),
                (b * 255).toInt()
            )
        }

        with(activity!!.window) {

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.VANILLA_ICE_CREAM) {
                Log.d("color tag",color.toString())
                decorView/*.apply {*/
                    .setOnApplyWindowInsetsListener { view, insets ->
                        insets.getInsets(WindowInsets.Type.statusBars()).let { statusBarInsets ->
                            view.setBackgroundColor(color)
                            //setPadding(0, statusBarInsets.top, 0, 0)
                        }
                        insets
                    }
                    //requestApplyInsets()
                //}
            } else {
                Log.d("",color.toString())
                statusBarColor = color
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
