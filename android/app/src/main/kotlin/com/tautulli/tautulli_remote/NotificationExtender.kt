package com.tautulli.tautulli_remote

import android.content.Context 
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.Drawable
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import com.bumptech.glide.annotation.GlideModule
import com.bumptech.glide.module.AppGlideModule
import com.bumptech.glide.request.target.CustomTarget
import com.bumptech.glide.request.transition.Transition
import com.onesignal.OSMutableNotification
import com.onesignal.OSNotification
import com.onesignal.OSNotificationReceivedEvent
import com.onesignal.OneSignal.OSRemoteNotificationReceivedHandler
import org.json.JSONException
import org.json.JSONObject
import java.net.URL
import java.net.URLConnection
import java.io.File
import java.io.IOException

import android.database.sqlite.SQLiteDatabase
import android.app.*

@GlideModule
class AppGlideModule : AppGlideModule()

class NotificationServiceExtension : OSRemoteNotificationReceivedHandler {
    override fun remoteNotificationReceived(context: Context, notificationReceivedEvent: OSNotificationReceivedEvent) {
        val notification: OSNotification = notificationReceivedEvent.getNotification()
        val data: JSONObject = notification.getAdditionalData()
        try {
            val serverId = data.getString("server_id")
            val serverInfoMap = getServerInfo(context, serverId)
            val deviceToken = serverInfoMap["deviceToken"]!!

            //* If encrypted decrypt the payload data
            val jsonMessage: JSONObject = if (data.getBoolean("encrypted")) {
                JSONObject(getUnencryptedMessage(data, deviceToken))
            } else {
                JSONObject(data.getString("plain_text"))
            }

            val notificationType: Int = jsonMessage.optInt("notification_type", 0)
            val body: String = jsonMessage.getString("body")
            val subject: String = jsonMessage.getString("subject")
            val priority: Int = jsonMessage.getInt("priority")

            //* Create an explicit intent
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            }
            val pendingIntent: PendingIntent = PendingIntent.getActivity(context, 0, intent, 0)

            val builder: NotificationCompat.Builder = NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(R.drawable.ic_stat_logo_flat)
                .setContentTitle(subject)
                .setContentText(body)
                .setStyle(NotificationCompat.BigTextStyle().bigText(body))
                .setColor(context.resources.getColor(R.color.amber))
                .setPriority(priority)
                //* Set the intent that will fire when the user taps the notification
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)

            createNotificationChannel(context)

            with(NotificationManagerCompat.from(context)) {
                //* Create notification id
                val tsLong: Long = System.currentTimeMillis()
                val ts = tsLong.toString()
                val tsTrunc: String = ts.substring(ts.length - 9)
                val notificationId: Int = Integer.parseInt(tsTrunc)

                // Fetch/add image and send notification if notification type is 1 or 2
                if (notificationType != 0) {
                    var posterThumb = jsonMessage.getString("poster_thumb")

                    if (!posterThumb.isNullOrEmpty()) {
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

                        GlideApp.with(context)
                            .asBitmap()
                            .load(urlString)
                            .into(object : CustomTarget<Bitmap>() {
                                override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
                                    builder.setLargeIcon(resource)

                                    if (notificationType == 2) {
                                        builder.setStyle(NotificationCompat.BigPictureStyle()
                                                .bigPicture(resource)
                                                .bigLargeIcon(null))
                                    }
                                    
                                     //* Send notification with image
                                    notify(notificationId, builder.build())
                                }

                                override fun onLoadCleared(placeholder: Drawable?) {}
                            })
                    }
                }

                //* Send notification
                notify(notificationId, builder.build())
            }

            //* Do not return original OneSignal notification
            notificationReceivedEvent.complete(null)
        } catch (e: JSONException) {
            e.printStackTrace()
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

    private fun getUnencryptedMessage(data: JSONObject?, deviceToken: String): String {
        if (data != null) {
            val salt: String = data.optString("salt", "")
            val cipherText: String = data.optString("cipher_text", "")
            val nonce: String = data.optString("nonce", "")

            if (salt != "" && cipherText != "" && nonce != "") {
                return DecryptAESGCM.decrypt(deviceToken, salt, cipherText, nonce)
            }
        }
        return ""
    }

    private fun getServerInfo(context: Context, serverId: String): Map<String, String> {
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
        
        return serverInfoMap
    }

    companion object {
        private const val CHANNEL_ID = "tautulli_remote"
        private const val LOG_TAG = "NotificationExtender"
    }
}