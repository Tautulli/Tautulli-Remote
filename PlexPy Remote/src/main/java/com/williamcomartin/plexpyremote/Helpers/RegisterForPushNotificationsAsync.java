package com.williamcomartin.plexpyremote.Helpers;

import android.content.SharedPreferences;
import android.net.Uri;
import android.os.AsyncTask;
import android.preference.PreferenceManager;
import android.util.Log;

import com.android.volley.Response;
import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.google.android.gms.iid.InstanceID;
import com.onesignal.OneSignal;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;
import com.williamcomartin.plexpyremote.Models.NoDataModels;
import com.williamcomartin.plexpyremote.R;

import java.io.IOException;
import java.net.MalformedURLException;

/**
 * Created by wcomartin on 2017-03-27.
 */

public class RegisterForPushNotificationsAsync {

    public RegisterForPushNotificationsAsync() {

    }

    public void execute() {
        OneSignal
                .startInit(ApplicationController.getInstance().getApplicationContext())
                .inFocusDisplaying(OneSignal.OSInFocusDisplayOption.None)
                .init();

        OneSignal.idsAvailable(new OneSignal.IdsAvailableHandler() {
            @Override
            public void idsAvailable(String userId, String registrationId) {
                Log.d("debug", "User:" + userId);
                if (registrationId != null)
                    Log.d("debug", "registrationId:" + registrationId);

                String deviceToken = userId;
                String deviceName = DeviceName.getDeviceName();

                // Log it for debugging purposes
                Log.d("MyApp", "Pushy device token: " + deviceToken + " - Device Name: " + deviceName);

                if (shouldRegister(deviceToken)) {
                    registerWithServer(deviceToken, deviceName);
                }
            }
        });
    }

    private boolean shouldRegister(String deviceToken) {
        SharedPreferences SP = PreferenceManager.getDefaultSharedPreferences(ApplicationController.getInstance().getApplicationContext());

        String host;
        try {
            host = UrlHelpers.getHost();
        } catch (NoServerException | MalformedURLException e) {
            return false;
        }

        String tokenKey = host + ":" + SP.getString("server_settings_apikey", "").trim();
        String storedDeviceToken = SP.getString(tokenKey, "").trim();

        return !storedDeviceToken.equals(deviceToken);

    }

    private void setRegistration(String deviceToken) {
        SharedPreferences SP = PreferenceManager.getDefaultSharedPreferences(ApplicationController.getInstance().getApplicationContext());
        SharedPreferences.Editor editor = SP.edit();

        String host = null;
        try {
            host = UrlHelpers.getHost();
        } catch (NoServerException | MalformedURLException ignored) {
        }

        String tokenKey = host + ":" + SP.getString("server_settings_apikey", "").trim();

        editor.putString(tokenKey, deviceToken);

        editor.apply();
    }

    private void registerWithServer(String deviceToken, String deviceName) {
        try {
            Uri.Builder uriBuilder = UrlHelpers.getUriBuilder();
            uriBuilder.appendQueryParameter("cmd", "register_device");
            uriBuilder.appendQueryParameter("device_id", deviceToken);
            uriBuilder.appendQueryParameter("device_name", deviceName);

            Log.d("RegistrationURL", uriBuilder.toString());

            GsonRequest<NoDataModels> request = new GsonRequest<>(
                    uriBuilder.toString(),
                    NoDataModels.class,
                    null,
                    requestListener(deviceToken),
                    errorListener()
            );

            RequestManager.addToRequestQueue(request);
        } catch (NoServerException | MalformedURLException e) {
            e.printStackTrace();
        }
    }

    private Response.ErrorListener errorListener() {
        return new ErrorListener(ApplicationController.getInstance().getApplicationContext());
    }

    private Response.Listener<NoDataModels> requestListener(final String deviceToken) {
        return new Response.Listener<NoDataModels>() {
            @Override
            public void onResponse(NoDataModels response) {
                if (response.response.result.equals("success")) {
                    setRegistration(deviceToken);
                }
            }
        };
    }
}
