package com.tautulli.tautulli_remote

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var channel: MethodChannel? = null

    /**
     * Notifications are built natively, so a tap arrives here as an Intent
     * rather than through the messaging plugin. The action was already decrypted
     * when the notification was posted, which spares the app repeating the key
     * derivation just to find out where to navigate.
     */
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel?.setMethodCallHandler { call, result ->
            when (call.method) {
                // Dart asks for the tap that launched the app; a tap on a running
                // app arrives through onNewIntent instead.
                "getLaunchNotification" -> {
                    result.success(notificationFrom(intent))
                    intent?.removeExtra(PushMessagingService.EXTRA_ACTION)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        notificationFrom(intent)?.let {
            channel?.invokeMethod("onNotificationTapped", it)
            intent.removeExtra(PushMessagingService.EXTRA_ACTION)
        }
    }

    private fun notificationFrom(intent: Intent?): Map<String, String>? {
        val action = intent?.getStringExtra(PushMessagingService.EXTRA_ACTION) ?: return null
        return mapOf(
            "action" to action,
            "server_id" to (intent.getStringExtra(PushMessagingService.EXTRA_SERVER_ID) ?: ""),
        )
    }

    companion object {
        private const val CHANNEL = "com.tautulli.tautulli_remote/notification_tap"
    }
}
