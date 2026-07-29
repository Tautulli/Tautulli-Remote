package com.tautulli.tautulli_remote

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.graphics.Bitmap
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone
import java.util.concurrent.TimeUnit

/**
 * Receives notifications forwarded by the Tautulli push relay.
 *
 * The relay only carries an opaque envelope: the notification is encrypted by
 * the user's own Tautulli server with a key derived from that server's device
 * token, so it can only be read here, on the device. This service decrypts it,
 * looks the server up in the app's database to fetch poster art, and builds the
 * notification.
 *
 * Declaring this service takes over from the firebase_messaging plugin's own,
 * which is what allows the payload to be decrypted before anything is shown.
 */
class PushMessagingService : FirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        val timestamp = utcTimestamp()
        val data = extractPayload(remoteMessage)

        if (data == null) {
            Log.e(LOG_TAG, "Notification payload is missing")
            appendDiagnosticLog(
                applicationContext,
                timestamp,
                encrypted = false,
                encryptionVersion = null,
                decryptionSuccess = null,
                decryptionError = "Notification payload is missing",
                imageRequested = false,
                imageSuccess = null,
                imageError = null,
            )
            return
        }

        var encrypted = false
        var encryptionVersion: Int? = null
        var decryptionSuccess: Boolean? = null

        try {
            val version = data.optInt("version", 1)
            val serverId = data.getString("server_id")
            val serverInfo = getServerInfo(applicationContext, serverId)
            val deviceToken = serverInfo["deviceToken"]
                ?: throw JSONException("No registered server matches $serverId")

            encrypted = data.getBoolean("encrypted")

            val message: JSONObject = if (encrypted) {
                encryptionVersion = version
                val decrypted = getUnencryptedMessage(data, version, deviceToken)
                if (decrypted.isEmpty()) {
                    decryptionSuccess = false
                    throw JSONException("Decryption returned empty result")
                }
                decryptionSuccess = true
                JSONObject(decrypted)
            } else {
                JSONObject(data.getString("plain_text"))
            }

            val subject = message.getString("subject")
            val body = message.getString("body")
            val priority = message.getInt("priority")
            val notificationType = message.optInt("notification_type", 0)
            val posterThumb = message.optString("poster_thumb", "")
            val action = message.optString("action", "")

            // Post immediately so the notification is never held up by artwork
            // that may be slow or unreachable; the poster is added by updating
            // this same notification once it loads.
            val notificationId = nextNotificationId()
            notify(notificationId, subject, body, priority, action, serverId, null, false)

            if (notificationType == 0 || posterThumb.isEmpty()) {
                appendDiagnosticLog(
                    applicationContext, timestamp, encrypted, encryptionVersion,
                    decryptionSuccess, null, imageRequested = false, imageSuccess = null, imageError = null,
                )
                return
            }

            val poster = loadPoster(serverInfo, deviceToken, posterThumb, notificationType)
            if (poster != null) {
                notify(notificationId, subject, body, priority, action, serverId, poster, notificationType == 2)
            }

            appendDiagnosticLog(
                applicationContext, timestamp, encrypted, encryptionVersion, decryptionSuccess, null,
                imageRequested = true,
                imageSuccess = poster != null,
                imageError = if (poster == null) "Image load failed or timed out" else null,
            )
        } catch (e: Exception) {
            Log.e(LOG_TAG, "Failed to handle notification: ${e.message}")
            if (encrypted && decryptionSuccess == null) {
                decryptionSuccess = false
            }
            appendDiagnosticLog(
                applicationContext, timestamp, encrypted, encryptionVersion, decryptionSuccess,
                e.message ?: "Decryption or parsing failed",
                imageRequested = false, imageSuccess = null, imageError = null,
            )
        }
    }

    /**
     * Declaring this service supersedes the firebase_messaging plugin's, so the
     * plugin's Dart-side token-refresh stream never fires on Android. Nothing is
     * recorded here: the app compares the token it holds against the one it last
     * registered on every launch, which catches a rotation whether or not it was
     * running when the token changed.
     */
    override fun onNewToken(token: String) {
        Log.i(LOG_TAG, "Push token rotated; servers are re-registered on next launch")
    }

    /**
     * Reads the relay envelope, falling back to the shape OneSignal used so a
     * notification already in flight during the migration still arrives.
     */
    private fun extractPayload(remoteMessage: RemoteMessage): JSONObject? {
        remoteMessage.data["payload"]?.let {
            return try {
                JSONObject(it)
            } catch (e: JSONException) {
                Log.e(LOG_TAG, "Notification payload is not valid JSON: ${e.message}")
                null
            }
        }

        return try {
            remoteMessage.data["custom"]?.let { JSONObject(it).optJSONObject("a") }
        } catch (e: JSONException) {
            null
        }
    }

    private fun notify(
        notificationId: Int,
        subject: String,
        body: String,
        priority: Int,
        action: String,
        serverId: String,
        poster: Bitmap?,
        bigPicture: Boolean,
    ) {
        createNotificationChannel(applicationContext)

        val intent = Intent(applicationContext, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra(EXTRA_ACTION, action)
            putExtra(EXTRA_SERVER_ID, serverId)
        }
        val pendingIntent = PendingIntent.getActivity(
            applicationContext,
            notificationId,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val builder = NotificationCompat.Builder(applicationContext, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_stat_logo_flat)
            .setColor(applicationContext.resources.getColor(R.color.amber))
            .setContentTitle(subject)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setPriority(priority)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            // Adding the poster updates this notification, which must not alert
            // the user a second time.
            .setOnlyAlertOnce(true)

        if (poster != null) {
            builder.setLargeIcon(poster)
            if (bigPicture) {
                builder.setStyle(
                    NotificationCompat.BigPictureStyle()
                        .bigPicture(poster)
                        .bigLargeIcon(null as Bitmap?)
                )
            }
        }

        val manager = NotificationManagerCompat.from(applicationContext)
        if (!manager.areNotificationsEnabled()) {
            Log.w(LOG_TAG, "Notifications are disabled for this app")
            return
        }

        try {
            manager.notify(notificationId, builder.build())
        } catch (e: SecurityException) {
            Log.w(LOG_TAG, "Not permitted to post notifications: ${e.message}")
        }
    }

    /**
     * Fetches poster art from the user's own Tautulli server. Runs on the
     * background thread that delivered the message, so the wait keeps the
     * service alive; it is bounded well inside the time the system allows.
     */
    private fun loadPoster(
        serverInfo: Map<String, String>,
        deviceToken: String,
        posterThumb: String,
        notificationType: Int,
    ): Bitmap? {
        val connectionAddress = if (serverInfo["primaryActive"] == "1") {
            serverInfo["primaryConnectionAddress"]
        } else {
            serverInfo["secondaryConnectionAddress"]
        }

        if (connectionAddress.isNullOrEmpty()) return null

        val size = if (notificationType == 1) "height=200" else "width=1080"
        val url = "$connectionAddress/api/v2?apikey=$deviceToken&cmd=pms_image_proxy" +
            "&app=true&img=$posterThumb&$size"

        return try {
            GlideApp.with(applicationContext)
                .asBitmap()
                .load(url)
                .submit()
                .get(POSTER_TIMEOUT_SECONDS, TimeUnit.SECONDS)
        } catch (e: Exception) {
            Log.w(LOG_TAG, "Failed to load poster: ${e.message}")
            null
        }
    }

    private fun appendDiagnosticLog(
        context: Context,
        timestamp: String,
        encrypted: Boolean,
        encryptionVersion: Int?,
        decryptionSuccess: Boolean?,
        decryptionError: String?,
        imageRequested: Boolean,
        imageSuccess: Boolean?,
        imageError: String?,
    ) {
        val entry = mapOf(
            "timestamp" to timestamp,
            "platform" to "android",
            "encrypted" to encrypted,
            "encryption_version" to encryptionVersion,
            "decryption_success" to decryptionSuccess,
            "decryption_error" to decryptionError,
            "image_requested" to imageRequested,
            "image_success" to imageSuccess,
            "image_error" to imageError,
        )

        try {
            val file = File(context.dataDir, "app_flutter/notification_diagnostic_log.json")

            val existing = if (file.exists()) {
                try { JSONArray(file.readText()) } catch (e: Exception) { JSONArray() }
            } else {
                JSONArray()
            }

            val newEntry = JSONObject()
            for ((key, value) in entry) {
                newEntry.put(key, value ?: JSONObject.NULL)
            }

            val combined = JSONArray()
            combined.put(newEntry)
            for (i in 0 until minOf(existing.length(), 49)) {
                combined.put(existing.get(i))
            }

            file.writeText(combined.toString())
        } catch (e: Exception) {
            Log.e(LOG_TAG, "Failed to write diagnostic log: ${e.message}")
        }
    }

    private fun createNotificationChannel(context: Context) {
        //* Create the NotificationChannel, but only on API 26+ because
        //* the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = context.resources.getString(R.string.channel_name)
            val descriptionText = context.resources.getString(R.string.channel_description)
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = descriptionText
            }
            //* Register the channel with the system
            val notificationManager: NotificationManager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun getUnencryptedMessage(data: JSONObject, version: Int, deviceToken: String): String {
        val salt: String = data.optString("salt", "")
        val cipherText: String = data.optString("cipher_text", "")
        val nonce: String = data.optString("nonce", "")

        if (salt != "" && cipherText != "" && nonce != "") {
            return DecryptAESGCM.decrypt(version, deviceToken, salt, cipherText, nonce)
        }

        Log.d(LOG_TAG, "Issues decrypting notification, required data missing")
        return ""
    }

    private fun getServerInfo(context: Context, serverId: String): Map<String, String> {
        val path = File(context.dataDir, "app_flutter/tautulli_remote.db")
        val db: SQLiteDatabase = SQLiteDatabase.openDatabase(path.absolutePath, null, 0)
        val query = "SELECT primary_connection_address, secondary_connection_address, " +
            "primary_active, device_token FROM servers WHERE tautulli_id = ?"

        var primaryConnectionAddress = ""
        var secondaryConnectionAddress = ""
        var primaryActive = ""
        var deviceToken = ""

        val cursor = db.rawQuery(query, arrayOf(serverId))
        if (cursor.moveToFirst()) {
            primaryConnectionAddress = cursor.getString(0)
            if (!cursor.isNull(1)) {
                secondaryConnectionAddress = cursor.getString(1)
            }
            primaryActive = cursor.getInt(2).toString()
            deviceToken = cursor.getString(3)
        }
        cursor.close()
        db.close()

        return mapOf(
            "primaryConnectionAddress" to primaryConnectionAddress,
            "secondaryConnectionAddress" to secondaryConnectionAddress,
            "primaryActive" to primaryActive,
            "deviceToken" to deviceToken,
        )
    }

    private fun utcTimestamp(): String {
        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US)
        sdf.timeZone = TimeZone.getTimeZone("UTC")
        return sdf.format(Date())
    }

    private fun nextNotificationId(): Int = (System.currentTimeMillis() and 0x7FFFFFFF).toInt()

    companion object {
        const val EXTRA_ACTION = "tautulli_notification_action"
        const val EXTRA_SERVER_ID = "tautulli_notification_server_id"

        private const val CHANNEL_ID = "tautulli_remote"
        private const val LOG_TAG = "TautulliPush"
        private const val POSTER_TIMEOUT_SECONDS = 10L
    }
}
