package com.williamcomartin.plexpyremote.Helpers;

import android.content.SharedPreferences;
import android.net.Uri;
import android.preference.PreferenceManager;
import android.util.Log;

import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;

import java.net.MalformedURLException;
import java.net.URL;

/**
 * Created by wcomartin on 2016-11-14.
 */

public class UrlHelpers {
    private static final SharedPreferences SP = PreferenceManager.getDefaultSharedPreferences(ApplicationController.getInstance().getApplicationContext());

    public static String getImageUrl (String image, String width, String height, String fallback){
        try {
            return UrlHelpers.getHostPlusAPIKey()
                    + "&cmd=pms_image_proxy&width=" + width
                    + "&height=" + height
                    + "&img=" + image
                    + "&fallback=" + fallback;
        } catch (NoServerException | MalformedURLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String getImageUrl (String image, String width, String height){
        return getImageUrl(image, width, height, "poster");
    }

    public static String getHost () throws NoServerException, MalformedURLException {
        if(SP.getString("server_settings_address", "").trim().equals("")){
            throw new NoServerException();
        }

        String protocol = SP.getBoolean("server_settings_ssl", false) ? "https" : "http";
        String host = SP.getString("server_settings_address", "").trim();

        int port = SP.getBoolean("server_settings_ssl", false) ? 443 : 80;
        try {
            port = Integer.parseInt(SP.getString("server_settings_port", ""));
        } catch (NumberFormatException ignored) {}

        String path = SP.getString("server_settings_path", "").trim();
        if(!path.startsWith("/")){
            path = "/" + path;
        }
        if(!path.endsWith("/")){
            path = path + "/";
        }

        URL url = new URL(protocol, host, port, path);
        return url.toString();
    }

    public static String getHostPlusAPIKey () throws NoServerException, MalformedURLException {
        return getHost() + "api/v2?apikey=" + SP.getString("server_settings_apikey", "").trim();
    }

    public static Uri.Builder getUriBuilder () throws NoServerException, MalformedURLException {
        Uri.Builder builder =  Uri.parse(getHost() + "api/v2").buildUpon();
        builder.appendQueryParameter("apikey", SP.getString("server_settings_apikey", "").trim());
        return builder;
    }
}
