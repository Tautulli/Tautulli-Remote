package com.williamcomartin.plexpyremote.Helpers;

import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;

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
        } catch (NoServerException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static String getImageUrl (String image, String width, String height){
        return getImageUrl(image, width, height, "poster");
    }

    public static String getHost () throws NoServerException {
        if(SP.getString("server_settings_address", "").equals("")){
            throw new NoServerException();
        }
        return SP.getString("server_settings_address", "");
    }

    public static String getHostPlusAPIKey () throws NoServerException {
        if(SP.getString("server_settings_address", "").equals("")){
            throw new NoServerException();
        }
        return SP.getString("server_settings_address", "")
                + "/api/v2?apikey=" + SP.getString("server_settings_apikey", "");
    }
}
