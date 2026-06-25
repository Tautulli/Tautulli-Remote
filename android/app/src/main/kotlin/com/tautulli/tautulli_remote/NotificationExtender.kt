package com.tautulli.tautulli_remote

import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.Drawable
import android.os.Build
import android.os.Handler;
import android.os.Looper;
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import com.bumptech.glide.annotation.GlideModule
import com.bumptech.glide.module.AppGlideModule
import com.bumptech.glide.request.target.CustomTarget
import com.bumptech.glide.request.transition.Transition
import com.onesignal.notifications.INotificationReceivedEvent
import com.onesignal.notifications.INotificationServiceExtension
import org.json.JSONArray
import org.json.JSONException
import org.json.JSONObject
import java.net.URL
import java.net.URLConnection
import java.io.File
import java.io.IOException
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone

import android.database.sqlite.SQLiteDatabase
import android.app.*

@GlideModule
class AppGlideModule : AppGlideModule()

class NotificationServiceExtension : INotificationServiceExtension {
    override fun onNotificationReceived(event: INotificationReceivedEvent) {
        val notification = event.notification
        val context = event.context
        val additionalData = notification.additionalData

        event.preventDefault()

        val sdf = SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US)
        sdf.timeZone = TimeZone.getTimeZone("UTC")
        val timestamp = sdf.format(Date())

        val data: JSONObject? = additionalData
        if (data == null) {
            Log.e("Tautulli Notification Info", "Additional data is null")
            notification.setExtender { builder ->
                builder.setSmallIcon(R.drawable.ic_stat_logo_flat)
                builder.setColor(context.resources.getColor(R.color.amber))
                builder
            }
            event.notification.display()
            appendDiagnosticLog(context, mapOf(
                "timestamp" to timestamp,
                "platform" to "android",
                "encrypted" to false,
                "encryption_version" to null,
                "decryption_success" to null,
                "decryption_error" to "Additional data is null",
                "image_requested" to false,
                "image_success" to null,
                "image_error" to null,
            ))
            return
        }

        var encrypted = false
        var encryptionVersion: Int? = null
        var decryptionSuccess: Boolean? = null
        var decryptionError: String? = null
        var imageRequested = false
        var logFromCallback = false
        var displayCalled = false

        try {
            val version = data.optInt("version", 1)
            val serverId = data.getString("server_id")
            val serverInfoMap = getServerInfo(context, serverId)
            val deviceToken = serverInfoMap["deviceToken"]!!

            encrypted = data.getBoolean("encrypted")

            val jsonMessage: JSONObject = if (encrypted) {
                encryptionVersion = version
                val decryptedStr = getUnencryptedMessage(data, version, deviceToken)
                if (decryptedStr.isEmpty()) {
                    decryptionSuccess = false
                    decryptionError = "Decryption failed"
                    throw JSONException("Decryption returned empty result")
                }
                decryptionSuccess = true
                JSONObject(decryptedStr)
            } else {
                JSONObject(data.getString("plain_text"))
            }

            Log.d("Tautulli Notification Info", "Notification content: $jsonMessage")

            val notificationType: Int = jsonMessage.optInt("notification_type", 0)
            val body: String = jsonMessage.getString("body")
            val subject: String = jsonMessage.getString("subject")
            val priority: Int = jsonMessage.getInt("priority")
            var posterThumb = jsonMessage.getString("poster_thumb")

            if (notificationType == 0 || posterThumb.isNullOrEmpty()) {
                notification.setExtender { builder ->
                    builder.setSmallIcon(R.drawable.ic_stat_logo_flat)
                    builder.setContentTitle(subject)
                    builder.setContentText(body)
                    builder.setStyle(NotificationCompat.BigTextStyle().bigText(body))
                    builder.setColor(context.resources.getColor(R.color.amber))
                    builder.setPriority(priority)
                    builder
                }

                event.notification.display()
                displayCalled = true
            } else {
                imageRequested = true
                logFromCallback = true

                var connectionAddress: String?
                if (serverInfoMap["primaryActive"] == "1") {
                    connectionAddress = serverInfoMap["primaryConnectionAddress"]
                } else {
                    connectionAddress = serverInfoMap["secondaryConnectionAddress"]
                }

                val urlString = if (notificationType == 1) {
                    "$connectionAddress/api/v2?apikey=$deviceToken&cmd=pms_image_proxy&app=true&img=$posterThumb&height=200"
                } else {
                    "$connectionAddress/api/v2?apikey=$deviceToken&cmd=pms_image_proxy&app=true&img=$posterThumb&width=1080"
                }

                val capturedEncrypted = encrypted
                val capturedEncryptionVersion = encryptionVersion
                val capturedDecryptionSuccess = decryptionSuccess
                val capturedDecryptionError = decryptionError

                Handler(Looper.getMainLooper()).postDelayed({
                    notification.setExtender { builder ->
                        builder.setSmallIcon(R.drawable.ic_stat_logo_flat)
                        builder.setContentTitle(subject)
                        builder.setContentText(body)
                        builder.setStyle(NotificationCompat.BigTextStyle().bigText(body))
                        builder.setColor(context.resources.getColor(R.color.amber))
                        builder.setPriority(priority)
                        builder
                    }
                    event.notification.display()

                    appendDiagnosticLog(context, mapOf(
                        "timestamp" to timestamp,
                        "platform" to "android",
                        "encrypted" to capturedEncrypted,
                        "encryption_version" to capturedEncryptionVersion,
                        "decryption_success" to capturedDecryptionSuccess,
                        "decryption_error" to capturedDecryptionError,
                        "image_requested" to true,
                        "image_success" to false,
                        "image_error" to "Sent without image after timeout",
                    ))
                }, 22500)

                GlideApp.with(context)
                    .asBitmap()
                    .load(urlString)
                    .timeout(22000)
                    .into(object : CustomTarget<Bitmap>() {
                        override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
                            notification.setExtender { builder ->
                                builder.setSmallIcon(R.drawable.ic_stat_logo_flat)
                                builder.setContentTitle(subject)
                                builder.setContentText(body)
                                builder.setStyle(NotificationCompat.BigTextStyle().bigText(body))
                                builder.setColor(context.resources.getColor(R.color.amber))
                                builder.setPriority(priority)
                                builder.setLargeIcon(resource)
                                builder
                            }

                            if (notificationType == 2) {
                                notification.setExtender { builder ->
                                    builder.setSmallIcon(R.drawable.ic_stat_logo_flat)
                                    builder.setContentTitle(subject)
                                    builder.setContentText(body)
                                    builder.setStyle(NotificationCompat.BigTextStyle().bigText(body))
                                    builder.setColor(context.resources.getColor(R.color.amber))
                                    builder.setPriority(priority)
                                    builder.setLargeIcon(resource)
                                    builder.setStyle(NotificationCompat.BigPictureStyle()
                                        .bigPicture(resource)
                                        .bigLargeIcon(null as Bitmap?))
                                    builder
                                }
                            }

                            event.notification.display()

                            appendDiagnosticLog(context, mapOf(
                                "timestamp" to timestamp,
                                "platform" to "android",
                                "encrypted" to capturedEncrypted,
                                "encryption_version" to capturedEncryptionVersion,
                                "decryption_success" to capturedDecryptionSuccess,
                                "decryption_error" to capturedDecryptionError,
                                "image_requested" to true,
                                "image_success" to true,
                                "image_error" to null,
                            ))
                        }

                        override fun onLoadFailed(errorDrawable: Drawable?) {
                            notification.setExtender { builder ->
                                builder.setSmallIcon(R.drawable.ic_stat_logo_flat)
                                builder.setContentTitle(subject)
                                builder.setContentText(body)
                                builder.setStyle(NotificationCompat.BigTextStyle().bigText(body))
                                builder.setColor(context.resources.getColor(R.color.amber))
                                builder.setPriority(priority)
                                builder
                            }
                            event.notification.display()
                            appendDiagnosticLog(context, mapOf(
                                "timestamp" to timestamp,
                                "platform" to "android",
                                "encrypted" to capturedEncrypted,
                                "encryption_version" to capturedEncryptionVersion,
                                "decryption_success" to capturedDecryptionSuccess,
                                "decryption_error" to capturedDecryptionError,
                                "image_requested" to true,
                                "image_success" to false,
                                "image_error" to "Image load failed",
                            ))
                        }

                        override fun onLoadCleared(placeholder: Drawable?) {}
                    })
            }
        } catch (e: Exception) {
            e.printStackTrace()
            if (encrypted && decryptionSuccess == null) {
                decryptionSuccess = false
                decryptionError = e.message ?: "Decryption or parsing failed"
            }
        } finally {
            if (!logFromCallback) {
                if (!displayCalled) {
                    notification.setExtender { builder ->
                        builder.setSmallIcon(R.drawable.ic_stat_logo_flat)
                        builder.setColor(context.resources.getColor(R.color.amber))
                        builder
                    }
                    event.notification.display()
                }
                appendDiagnosticLog(context, mapOf(
                    "timestamp" to timestamp,
                    "platform" to "android",
                    "encrypted" to encrypted,
                    "encryption_version" to encryptionVersion,
                    "decryption_success" to decryptionSuccess,
                    "decryption_error" to decryptionError,
                    "image_requested" to imageRequested,
                    "image_success" to null,
                    "image_error" to null,
                ))
            }
        }
    }

    private fun appendDiagnosticLog(context: Context, entry: Map<String, Any?>) {
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
            Log.e("Tautulli Notification Info", "Failed to write diagnostic log: ${e.message}")
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

    private fun getUnencryptedMessage(data: JSONObject?, version: Int, deviceToken: String): String {
        Log.d("Tautulli Notification Info", "Encypted notification received...")
        if (data != null) {
            val salt: String = data.optString("salt", "")
            val cipherText: String = data.optString("cipher_text", "")
            val nonce: String = data.optString("nonce", "")

            if (salt != "" && cipherText != "" && nonce != "") {
                Log.d("Tautulli Notification Info", "Decrypting Notification...")
                return DecryptAESGCM.decrypt(version, deviceToken, salt, cipherText, nonce)
            }
        }
        Log.d("Tautulli Notification Info", "Issues decrypting notification, required data missing")
        return ""
    }

    private fun getServerInfo(context: Context, serverId: String): Map<String, String> {
        Log.d("Tautulli Notification Info", "Fetching server info for $serverId")

        val documentDir = context.dataDir
        val path = File(documentDir, "app_flutter/tautulli_remote.db")
        val db: SQLiteDatabase = SQLiteDatabase.openDatabase(path.absolutePath, null, 0)
        val query = "SELECT primary_connection_address, secondary_connection_address, primary_active, device_token FROM servers WHERE tautulli_id = \'$serverId\'"

        var primaryConnectionAddress = ""
        var secondaryConnectionAddress = ""
        var primaryActive = ""
        var deviceToken = ""

        val cursor = db.rawQuery(query, null)
        if (cursor.moveToFirst()) {
            cursor.moveToFirst()
            primaryConnectionAddress = cursor.getString(0)
            if (!cursor.isNull(1)) {
                secondaryConnectionAddress = cursor.getString(1)
            }
            primaryActive = cursor.getInt(2).toString()
            deviceToken = cursor.getString(3)
            cursor.close()
        }
        db.close()

        val serverInfoMap = mapOf("primaryConnectionAddress" to primaryConnectionAddress, "secondaryConnectionAddress" to secondaryConnectionAddress, "primaryActive" to primaryActive, "deviceToken" to deviceToken)

        Log.d("Tautulli Notification Info", "Server info found: $serverInfoMap")

        return serverInfoMap
    }

    companion object {
        private const val CHANNEL_ID = "tautulli_remote"
        private const val LOG_TAG = "NotificationExtender"
    }
}
