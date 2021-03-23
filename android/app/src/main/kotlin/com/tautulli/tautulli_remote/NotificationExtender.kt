package com.tautulli.tautulli_remote

import android.content.Context 
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import com.onesignal.NotificationExtenderService
import com.onesignal.OSNotificationReceivedResult
import org.json.JSONException
import org.json.JSONObject
import java.net.URL
import java.net.URLConnection
import java.io.File
// import java.io.IOException

import android.database.sqlite.SQLiteDatabase
import android.app.*


/**
 * Created by wcomartin on 2017-04-18.
 * Updated by wcomartin on 2020-07-19 (converted to kotlin)
 */
class NotificationExtender : NotificationExtenderService() {
    override fun onNotificationProcessing(notification: OSNotificationReceivedResult): Boolean {
        val data: JSONObject = notification.payload.additionalData
        try {
            // val serverId = data.getString("server_id")
            //* If encrypted decrypt the payload data
            val jsonMessage: JSONObject = if (data.getBoolean("encrypted")) {
                JSONObject(getUnencryptedMessage(data))
            } else {
                JSONObject(data.getString("plain_text"))
            }

            // val serverInfoMap = getServerInfo(serverId)

            // var connectionAddress: String?
            // val deviceToken = serverInfoMap["deviceToken"]
            // if (serverInfoMap["primaryActive"] == "1") {
            //     connectionAddress = serverInfoMap["primaryConnectionAddress"]
            // } else {
            //     connectionAddress = serverInfoMap["secondaryConnectionAddress"]
            // } 

            // val urlString = "$connectionAddress/api/v2?apikey=$deviceToken&cmd=pms_image_proxy&app=true&img=${jsonMessage.getString("poster_thumb")}&height=200"
            // val bitmap: Bitmap? = getBitmapFromURL(urlString)

            val body: String = jsonMessage.getString("body")
            val subject: String = jsonMessage.getString("subject")
            val priority: Int = jsonMessage.getInt("priority")

            //* Create an explicit intent
            val intent = Intent(this, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
            }
            val pendingIntent: PendingIntent = PendingIntent.getActivity(this, 0, intent, 0)

            val builder: NotificationCompat.Builder = NotificationCompat.Builder(this, CHANNEL_ID)
                .setSmallIcon(R.drawable.ic_stat_logo_flat)
                .setContentTitle(subject)
                .setContentText(body)
                .setStyle(NotificationCompat.BigTextStyle().bigText(body))
                .setColor(ContextCompat.getColor(applicationContext, R.color.amber))
                .setPriority(priority)
                //* Set the intent that will fire when the user taps the notification
                .setContentIntent(pendingIntent)
                .setAutoCancel(true)
                // .setLargeIcon(bitmap)

            createNotificationChannel()

            with(NotificationManagerCompat.from(this)) {
                //* Create notification id
                val tsLong: Long = System.currentTimeMillis()
                val ts = tsLong.toString()
                val tsTrunc: String = ts.substring(ts.length - 9)
                val notificationId: Int = Integer.parseInt(tsTrunc)

                //* Send notification
                notify(notificationId, builder.build())
            }

            //* Do not return original OneSignal notification
            return true
        } catch (e: JSONException) {
            e.printStackTrace()
        }
        return false
    }

    private fun createNotificationChannel() {
        //* Create the NotificationChannel, but only on API 26+ because
        //* the NotificationChannel class is new and not in the support library
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val name = getString(R.string.channel_name)
            val descriptionText = getString(R.string.channel_description)
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel(CHANNEL_ID, name, importance).apply {
                description = descriptionText
            }
            //* Register the channel with the system
            val notificationManager: NotificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun getUnencryptedMessage(data: JSONObject?): String {
        if (data != null) {

            val serverId = data.getString("server_id")
            val deviceToken = getServerDeviceToken(serverId)

            val salt: String = data.optString("salt", "")
            val cipherText: String = data.optString("cipher_text", "")
            val nonce: String = data.optString("nonce", "")

            if (salt != "" && cipherText != "" && nonce != "") {
                return DecryptAESGCM.decrypt(deviceToken, salt, cipherText, nonce)
            }
        }
        return ""
    }

    private fun getServerDeviceToken(serverId: String): String {
        val documentDir = application.applicationContext.dataDir
        val path = File(documentDir, "app_flutter/tautulli_remote.db")
        val db: SQLiteDatabase = SQLiteDatabase.openDatabase(path.absolutePath, null, 0)
        val query = "SELECT device_token FROM servers WHERE tautulli_id = \"$serverId\""

        var deviceToken = ""

        val cursor = db.rawQuery(query, null)
        if (cursor.moveToFirst()) {
            cursor.moveToFirst()
            deviceToken = cursor.getString(0)
            cursor.close()
        }
        db.close()
        return deviceToken
    }

    // private fun getServerInfo(serverId: String): Map<String, String> {
    //     val documentDir = application.applicationContext.dataDir
    //     val path = File(documentDir, "app_flutter/tautulli_remote.db")
    //     val db: SQLiteDatabase = SQLiteDatabase.openDatabase(path.absolutePath, null, 0)
    //     val query = "SELECT primary_connection_address, secondary_connection_address, primary_active, device_token FROM servers WHERE tautulli_id = \"$serverId\""

    //     var primaryConnectionAddress = ""
    //     var secondaryConnectionAddress = ""
    //     var primaryActive = ""
    //     var deviceToken = ""

    //     val cursor = db.rawQuery(query, null)
    //     if (cursor.moveToFirst()) {
    //         cursor.moveToFirst()
    //         primaryConnectionAddress = cursor.getString(0)
    //         if (!cursor.isNull(1)) {
    //             secondaryConnectionAddress = cursor.getString(1)
    //         }
    //         primaryActive = cursor.getInt(2).toString()
    //         deviceToken = cursor.getString(3)
    //         cursor.close()
    //     }
    //     db.close()

    //     val serverInfoMap = mapOf("primaryConnectionAddress" to primaryConnectionAddress, "secondaryConnectionAddress" to secondaryConnectionAddress, "primaryActive" to primaryActive, "deviceToken" to deviceToken)
        
    //     return serverInfoMap
    // }

    // fun getBitmapFromURL(urlString:String):Bitmap? {
    //     try {
    //         val url = URL(urlString)
    //         val connection = url.openConnection()
    //         connection.setDoInput(true)
    //         connection.connect()
    //         val input = connection.getInputStream()
    //         val myBitmap = BitmapFactory.decodeStream(input)
    //         return myBitmap
    //     } catch (e: IOException) {
    //         e.printStackTrace()
    //         return null
    //     }
    // }

    companion object {
        private const val CHANNEL_ID = "tautulli_remote"
        private const val LOG_TAG = "NotificationExtender"
    }
}