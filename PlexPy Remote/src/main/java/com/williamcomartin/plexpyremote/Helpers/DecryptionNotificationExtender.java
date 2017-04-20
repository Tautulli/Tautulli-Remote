package com.williamcomartin.plexpyremote.Helpers;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.support.v4.app.NotificationCompat;
import android.util.Base64;
import android.util.Log;

import com.onesignal.NotificationExtenderService;
import com.onesignal.OSNotificationDisplayedResult;
import com.onesignal.OSNotificationReceivedResult;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.R;

import org.json.JSONException;
import org.json.JSONObject;

import java.math.BigInteger;
import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;

/**
 * Created by wcomartin on 2017-04-18.
 */

public class DecryptionNotificationExtender extends NotificationExtenderService {

    private static final SharedPreferences SP = PreferenceManager.getDefaultSharedPreferences(ApplicationController.getInstance().getApplicationContext());

    @Override
    protected boolean onNotificationProcessing(OSNotificationReceivedResult notification) {
        Log.d("DecryptionNotification", notification.payload.additionalData.toString());

        JSONObject data = notification.payload.additionalData;

        try {
            final JSONObject jsonMessage;
            if(data.getBoolean("encrypted")) {
                jsonMessage = new JSONObject(GetUnencryptedMessage(data));
            } else {
                jsonMessage = new JSONObject(data.getString("plain_text"));
            }

            final String body = jsonMessage.getString("body");
            final String subject = jsonMessage.getString("subject");
            final int priority = jsonMessage.getInt("priority");

            Log.d("DecryptionNotification", jsonMessage.toString());

            NotificationCompat.Builder mBuilder =
                    new NotificationCompat.Builder(this)
                            .setSmallIcon(R.mipmap.ic_launcher)
                            .setContentTitle(subject)
                            .setContentText(body)
                            .setPriority(priority)
                            .setAutoCancel(true)
                            .setStyle(new NotificationCompat.BigTextStyle().bigText(body))
                            .setColor(getResources().getColor(R.color.colorAccent));

            Long tsLong = System.currentTimeMillis();
            String ts = tsLong.toString();
            String tsTrunc = ts.substring(ts.length() - 9);
            int notificationID = Integer.parseInt(tsTrunc);

            NotificationManager mNotifyMgr =
                    (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
            mNotifyMgr.notify(notificationID, mBuilder.build());

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

            String ApiKey = SP.getString("server_settings_apikey", "").trim();

            if (salt != null && cipherText != null && nonce != null) {
                return DecryptAESGCM.Decrypt(ApiKey, salt, cipherText, nonce);
            }
        }
        return "";
    }


}
