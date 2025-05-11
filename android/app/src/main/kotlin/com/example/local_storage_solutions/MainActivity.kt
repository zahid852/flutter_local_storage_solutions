package com.example.local_storage_solutions

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity()
{
    private val CHANNEL = "com.example.myapp/channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getNativeData") {
                val data = "Hello from Kotlin!"
                result.success(data)
            } else {
                result.notImplemented()
            }
        }
    }
}