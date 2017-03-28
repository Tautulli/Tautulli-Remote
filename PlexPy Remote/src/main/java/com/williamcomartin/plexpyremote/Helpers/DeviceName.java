package com.williamcomartin.plexpyremote.Helpers;

import android.provider.Settings;

import com.williamcomartin.plexpyremote.ApplicationController;

/**
 * Created by wcomartin on 2017-03-27.
 */

public class DeviceName {
    public static String getDeviceName() {
        String deviceName = Settings.System.getString(ApplicationController.getInstance().getContentResolver(), "device_name");
        if(deviceName != null) return deviceName;

        deviceName = android.os.Build.MODEL;
        if(deviceName != null) return deviceName;

        return "";
    }
}
