package com.williamcomartin.plexpyremote.Helpers;

import android.content.SharedPreferences;
import android.net.Uri;
import android.os.AsyncTask;
import android.preference.PreferenceManager;
import android.util.Log;

import com.android.volley.Response;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;
import com.williamcomartin.plexpyremote.Models.NoDataModels;

import java.net.MalformedURLException;

import me.pushy.sdk.Pushy;

/**
 * Created by wcomartin on 2017-03-27.
 */

public class RegisterForPushNotificationsAsync extends AsyncTask<Void, Void, Exception> {
    protected Exception doInBackground(Void... params) {
        try {
            // Assign a unique token to this device
            String deviceToken = Pushy.register(ApplicationController.getInstance().getApplicationContext());
            String deviceName = DeviceName.getDeviceName();

            // Log it for debugging purposes
            Log.d("MyApp", "Pushy device token: " + deviceToken + " - Device Name: " + deviceName);

            if(shouldRegister(deviceToken)){
                registerWithServer(deviceToken, deviceName);
            }
        } catch (Exception exc) {
            return exc;
        }
        return null;
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
        } catch (NoServerException | MalformedURLException ignored) {}

        String tokenKey = host + ":" + SP.getString("server_settings_apikey", "").trim();

        editor.putString(tokenKey, deviceToken);

        editor.apply();
    }

    private void registerWithServer(String deviceToken, String deviceName) {
        try {
            Uri.Builder uriBuilder = UrlHelpers.getUriBuilder();
            uriBuilder.appendQueryParameter("cmd", "register_device");
            uriBuilder.appendQueryParameter("device_token", deviceToken);
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
                if(response.response.result.equals("success")){
                    setRegistration(deviceToken);
                }
            }
        };
    }
}
