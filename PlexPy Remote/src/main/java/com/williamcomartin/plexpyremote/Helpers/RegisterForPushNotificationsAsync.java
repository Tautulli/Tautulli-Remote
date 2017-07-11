package com.williamcomartin.plexpyremote.Helpers;

import android.content.SharedPreferences;
import android.net.Uri;
import android.preference.PreferenceManager;
import android.util.Log;

import com.android.volley.Response;
import com.onesignal.OneSignal;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;
import com.williamcomartin.plexpyremote.Models.NoDataModels;

import java.net.MalformedURLException;

/**
 * Created by wcomartin on 2017-03-27.
 */

public class RegisterForPushNotificationsAsync {

    private SharedPreferences.Editor spEditor;
    private SharedPreferences sharedPreferences;

    public RegisterForPushNotificationsAsync() {
        sharedPreferences = PreferenceManager.getDefaultSharedPreferences(ApplicationController.getInstance().getApplicationContext());
        spEditor = sharedPreferences.edit();
    }

    public void execute() {
        String deviceName = DeviceName.getDeviceName();
        String deviceToken = sharedPreferences.getString("one_signal_device_token", "");

        if(deviceToken.equals("")) {
            if (shouldRegister(deviceToken)) {
                registerWithServer(deviceToken, deviceName);
            }
        } else {
            registerOneSignal(deviceName);
        }
    }

    private void registerOneSignal(final String deviceName) {
        OneSignal
                .startInit(ApplicationController.getInstance().getApplicationContext())
                .inFocusDisplaying(OneSignal.OSInFocusDisplayOption.None)
                .init();

        OneSignal.idsAvailable(new OneSignal.IdsAvailableHandler() {
            @Override
            public void idsAvailable(String userId, String registrationId) {
                String deviceToken = userId;
                spEditor.putString("one_signal_device_token", userId);
                spEditor.commit();

                // Log it for debugging purposes
                Log.d("RegisterNotifications", "OneSignal device token: " + deviceToken + " - Device Name: " + deviceName);

                if (shouldRegister(deviceToken)) {
                    registerWithServer(deviceToken, deviceName);
                }
            }
        });
    }

    private boolean shouldRegister(String deviceToken) {

        String host;
        try {
            host = UrlHelpers.getHost();
        } catch (NoServerException | MalformedURLException e) {
            return false;
        }

        String tokenKey = host + ":" + sharedPreferences.getString("server_settings_apikey", "").trim();
        String storedDeviceToken = sharedPreferences.getString(tokenKey, "").trim();

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
