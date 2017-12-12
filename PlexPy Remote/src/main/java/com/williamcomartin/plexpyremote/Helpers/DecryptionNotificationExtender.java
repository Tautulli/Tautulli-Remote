package com.williamcomartin.plexpyremote.Helpers;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.preference.PreferenceManager;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

import com.onesignal.NotificationExtenderService;
import com.onesignal.OSNotificationReceivedResult;
import com.williamcomartin.plexpyremote.ActivityActivity;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.R;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.URL;
import java.net.URLConnection;

/**
 * Created by wcomartin on 2017-04-18.
 */

public class DecryptionNotificationExtender extends NotificationExtenderService {

    private static final SharedPreferences SP = PreferenceManager.getDefaultSharedPreferences(ApplicationController.getInstance().getApplicationContext());

    private static final String CHANNEL_ID = "plexpy_remote_main";
    private NotificationChannel mChannel;

    @Override
    protected boolean onNotificationProcessing(OSNotificationReceivedResult notification) {
        JSONObject data = notification.payload.additionalData;

        try {
            final JSONObject jsonMessage;
            if (data.getBoolean("encrypted")) {
                jsonMessage = new JSONObject(GetUnencryptedMessage(data));
            } else {
                jsonMessage = new JSONObject(data.getString("plain_text"));
            }

            final String body = jsonMessage.getString("body");
            final String subject = jsonMessage.getString("subject");
            final int priority = jsonMessage.getInt("priority");

            Bitmap icon;

            Log.d("Notification", jsonMessage.getString("poster_thumb"));
            try {
                String urlString = UrlHelpers.getImageUrl(jsonMessage.getString("poster_thumb"), "200", "200");
                Log.d("Notification", urlString);
                URL url = new URL(urlString);
                URLConnection urlConnection = url.openConnection();
                urlConnection.setReadTimeout(10000);
                urlConnection.setConnectTimeout(10000);
                icon = BitmapFactory.decodeStream(urlConnection.getInputStream());
            } catch(Exception e) {
                Log.d("Notification", e.toString());
                e.printStackTrace();
                icon = BitmapFactory.decodeResource(getResources(),
                        R.drawable.placeholder_poster);
            }

            Intent launchIntent = new Intent(this, ActivityActivity.class);
            launchIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);

            PendingIntent resultPendingIntent = PendingIntent.getActivity(this, 0, launchIntent, PendingIntent.FLAG_UPDATE_CURRENT);

            Long tsLong = System.currentTimeMillis();
            String ts = tsLong.toString();
            String tsTrunc = ts.substring(ts.length() - 9);
            int notificationID = Integer.parseInt(tsTrunc);

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                CharSequence name = getString(R.string.app_name);
                int importance = NotificationManager.IMPORTANCE_DEFAULT;
                mChannel = new NotificationChannel(CHANNEL_ID, name, importance);

                Notification.Builder mBuilder = new Notification.Builder(this, CHANNEL_ID)
                        .setSmallIcon(R.mipmap.ic_launcher)
                        .setContentTitle(subject)
                        .setContentText(body)
                        .setAutoCancel(true)
                        .setContentIntent(resultPendingIntent)
                        .setStyle(new Notification.MediaStyle())
                        .setColor(getResources().getColor(R.color.colorAccent))
                        .setLargeIcon(icon);

                NotificationManager mNotifyMgr = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
                mNotifyMgr.createNotificationChannel(mChannel);
                mNotifyMgr.notify(notificationID, mBuilder.build());
            } else {
                NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(this, CHANNEL_ID)
                        .setSmallIcon(R.mipmap.ic_launcher)
                        .setContentTitle(subject)
                        .setContentText(body)
                        .setPriority(priority)
                        .setAutoCancel(true)
                        .setContentIntent(resultPendingIntent)
                        .setLargeIcon(icon)
                        .setColor(getResources().getColor(R.color.colorAccent))
                        .setStyle(new NotificationCompat.BigTextStyle().bigText(body));

                NotificationManager mNotifyMgr = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
                mNotifyMgr.notify(notificationID, mBuilder.build());
            }
            return true;

        } catch (JSONException e) {
            e.printStackTrace();
        }
        return false;
    }

    private String GetUnencryptedMessage(JSONObject data) {
        if (data != null) {
            String salt = data.optString("salt", null);
            String cipherText = data.optString("cipher_text", null);
            String nonce = data.optString("nonce", null);

            String apiKey = SP.getString("server_settings_apikey", "").trim();

            if (salt != null && cipherText != null && nonce != null) {
                return DecryptAESGCM.Decrypt(apiKey, salt, cipherText, nonce);
            }
        }
        return "";
    }


}
