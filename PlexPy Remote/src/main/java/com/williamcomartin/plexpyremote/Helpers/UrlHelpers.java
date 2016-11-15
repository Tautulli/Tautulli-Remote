package com.williamcomartin.plexpyremote.Helpers;

import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import com.williamcomartin.plexpyremote.ApplicationController;

/**
 * Created by wcomartin on 2016-11-14.
 */

public class UrlHelpers {
    private static final SharedPreferences SP = PreferenceManager.getDefaultSharedPreferences(ApplicationController.getInstance().getApplicationContext());

    public static String getImageUrl (String image, String width, String height, String fallback){
        return UrlHelpers.getHostPlusAPIKey()
                + "&cmd=pms_image_proxy&width=" + width
                + "&height=" + height
                + "&img=" + image
                + "&fallback=" + fallback;
    }

    public static String getImageUrl (String image, String width, String height){
        return UrlHelpers.getHostPlusAPIKey()
                + "&cmd=pms_image_proxy&width=" + width
                + "&height=" + height
                + "&img=" + image
                + "&fallback=poster";
    }

    public static String getHostPlusAPIKey (){
        return SP.getString("server_settings_address", "")
                + "/api/v2?apikey=" + SP.getString("server_settings_apikey", "");
    }
}
