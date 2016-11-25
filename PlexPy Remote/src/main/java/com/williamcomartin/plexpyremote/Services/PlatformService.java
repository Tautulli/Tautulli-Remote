package com.williamcomartin.plexpyremote.Services;

import android.util.Log;

import com.williamcomartin.plexpyremote.R;

/**
 * Created by wcomartin on 16-05-22.
 */
public class PlatformService {
    public static PlatformService mInstance;

    public static PlatformService getInstance() {
        if (mInstance == null) {
            Class clazz = PlatformService.class;
            synchronized (clazz) {
                mInstance = new PlatformService();
            }
        }
        return mInstance;
    }

    public int getPlatformImagePath(String platformName) {

        Log.d("GetPlatformImagePath", platformName);

        switch(platformName) {
            case "Roku":
                return R.drawable.platform_roku;
            case "Apple TV":
                return R.drawable.platform_atv;
            case "tvOS":
                return R.drawable.platform_atv;
            case "Firefox":
                return R.drawable.platform_firefox;
            case "Chromecast":
                return R.drawable.platform_chromecast;
            case "Chrome":
                return R.drawable.platform_chrome;
            case "Android":
                return R.drawable.platform_android;
            case "Nexus":
                return R.drawable.platform_android;
            case "iPad":
                return R.drawable.platform_ios;
            case "iPhone":
                return R.drawable.platform_ios;
            case "iOS":
                return R.drawable.platform_ios;
            case "Plex Home Theater":
                return R.drawable.platform_pht;
            case "Linux/RPi-XMBC":
                return R.drawable.platform_xbmc;
            case "Safari":
                return R.drawable.platform_safari;
            case "Internet Explorer":
                return R.drawable.platform_ie;
            case "Microsoft Edge":
                return R.drawable.platform_msedge;
            case "Unknown Browser":
                return R.drawable.platform_default;
            case "Windows-XBMC":
                return R.drawable.platform_xbmc;
            case "Xbox":
                return R.drawable.platform_xbox;
            case "Samsung":
                return R.drawable.platform_samsung;
            case "Opera":
                return R.drawable.platform_opera;
            case "KODI":
                return R.drawable.platform_kodi;
            case "Playstation 3":
                return R.drawable.platform_playstation;
            case "Playstation 4":
                return R.drawable.platform_playstation;
            case "Xbox 360":
                return R.drawable.platform_xbox;
            case "Windows":
                return R.drawable.platform_win8;
            case "Windows phone":
                return R.drawable.platform_wp;
            case "Plex Media Player":
                return R.drawable.platform_pmp;
            case "DLNA":
                return R.drawable.platform_dlna;

            default:
                return R.drawable.platform_default;
        }
    }
}
