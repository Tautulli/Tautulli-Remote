package com.tautulli.tautulli_remote

import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import com.onesignal.NotificationExtenderService
import com.onesignal.OSNotificationReceivedResult
import org.json.JSONException
import org.json.JSONObject
import java.net.URL
import java.net.URLConnection
import java.io.File

import android.database.sqlite.SQLiteDatabase
import android.app.*


/**
 * Created by wcomartin on 2017-04-18.
 * Updated by wcomartin on 2020-07-19 (converted to kotlin)
 */
class NotificationExtender : NotificationExtenderService() {
    override fun onNotificationProcessing(notification: OSNotificationReceivedResult): Boolean {
        Log.d(LOG_TAG, notification.payload.additionalData.toString())

        val data: JSONObject = notification.payload.additionalData
        try {

            val jsonMessage: JSONObject = if (data.getBoolean("encrypted")) {
                JSONObject(getUnencryptedMessage(data))
            } else {
                JSONObject(data.getString("plain_text"))
            }

            val body: String = jsonMessage.getString("body")
            val subject: String = jsonMessage.getString("subject")
            val priority: Int = jsonMessage.getInt("priority")

            Log.d("Notification", jsonMessage.getString("poster_thumb"))

            val launchIntent = Intent(this, MainActivity::class.java)
            launchIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK

            val resultPendingIntent: PendingIntent = PendingIntent.getActivity(this, 0, launchIntent, PendingIntent.FLAG_UPDATE_CURRENT)

            val tsLong: Long = System.currentTimeMillis()
            val ts = tsLong.toString()
            val tsTrunc: String = ts.substring(ts.length - 9)
            val notificationID: Int = Integer.parseInt(tsTrunc)

            Log.d(LOG_TAG, subject)
            Log.d(LOG_TAG, body)

            val mBuilder: NotificationCompat.Builder = NotificationCompat.Builder(this, CHANNEL_ID)
                .setSmallIcon(R.drawable.ic_stat_logo_flat)
                .setContentTitle(subject)
                .setContentText(body)
                .setPriority(priority)
                .setAutoCancel(true)
                .setContentIntent(resultPendingIntent)
                .setColor(ContextCompat.getColor(applicationContext, R.color.amber))
                .setStyle(NotificationCompat.BigTextStyle().bigText(body))

             val mNotifyMgr: NotificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
                mNotifyMgr.notify(notificationID, mBuilder.build())
            return true
        } catch (e: JSONException) {
            e.printStackTrace()
        }
        return false
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

    companion object {
        private const val CHANNEL_ID = "tautulli_remote_main"
        private const val LOG_TAG = "NotificationExtender"
    }
}