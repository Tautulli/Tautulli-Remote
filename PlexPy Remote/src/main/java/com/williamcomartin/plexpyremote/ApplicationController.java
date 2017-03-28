package com.williamcomartin.plexpyremote;

import android.app.Application;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.preference.PreferenceManager;

import com.williamcomartin.plexpyremote.Helpers.RegisterForPushNotificationsAsync;
import com.williamcomartin.plexpyremote.Helpers.NukeSSLCerts;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.ImageCacheManager;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;

import java.net.MalformedURLException;
import java.net.URL;

/**
 * Created by wcomartin on 2015-11-29.
 */
public class ApplicationController extends Application {

    private static ApplicationController mInstance;

    @Override
    public void onCreate() {
        super.onCreate();
        NukeSSLCerts.nuke();
        mInstance = this;
        RequestManager.init(mInstance);
        ImageCacheManager.getInstance().init(mInstance, mInstance.getPackageCodePath(),
                1024 * 1024 * 100, Bitmap.CompressFormat.PNG, 100);

        stepOpenCount();

        parseServerForBackwardsCompatibility();


        new RegisterForPushNotificationsAsync().execute();
    }

    public static synchronized ApplicationController getInstance() {
        return mInstance;
    }

    public void stepOpenCount() {
        SharedPreferences sharedPref = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
        int currentCount = sharedPref.getInt("AppOpenCount", 0);
        SharedPreferences.Editor editor = sharedPref.edit();
        editor.putInt("AppOpenCount", currentCount + 1);
        editor.apply();
    }

    public void parseServerForBackwardsCompatibility() {
        SharedPreferences sharedPref = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
        SharedPreferences.Editor editor = sharedPref.edit();

        String serverAddress = sharedPref.getString("server_settings_address", "");

        if(serverAddress.startsWith("http")) {
            try {
                URL oldUrl = new URL(serverAddress);

                boolean serverSSL = oldUrl.getProtocol().equals("https");
                String serverHost = oldUrl.getHost();
                int serverPort = oldUrl.getPort();
                String serverPath = oldUrl.getPath();

                editor.putBoolean("server_settings_ssl", serverSSL);
                editor.putString("server_settings_address", serverHost);
                if(serverPort != -1) {
                    editor.putString("server_settings_port", String.valueOf(serverPort));
                } else {
                    editor.putString("server_settings_port", serverSSL ? "443" : "80");
                }
                editor.putString("server_settings_path", serverPath);

                editor.apply();

            } catch (MalformedURLException e) {
                e.printStackTrace();
            }
        }
    }
}
