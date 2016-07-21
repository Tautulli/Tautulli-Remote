package com.williamcomartin.plexpyremote.Services;

import android.util.Log;

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

    public String getPlatformImagePath(String platformName) {

        Log.d("GetPlatformImagePath", platformName);

        switch(platformName) {
            case "Roku":
                return "/images/platforms/roku.png";
            case "Apple TV":
                return "/images/platforms/atv.png";
            case "tvOS":
                return "/images/platforms/atv.png";
            case "Firefox":
                return "/images/platforms/firefox.png";
            case "Chromecast":
                return "/images/platforms/chromecast.png";
            case "Chrome":
                return "/images/platforms/chrome.png";
            case "Android":
                return "/images/platforms/android.png";
            case "Nexus":
                return "/images/platforms/android.png";
            case "iPad":
                return "/images/platforms/ios.png";
            case "iPhone":
                return "/images/platforms/ios.png";
            case "iOS":
                return "/images/platforms/ios.png";
            case "Plex Home Theater":
                return "/images/platforms/pht.png";
            case "Linux/RPi-XMBC":
                return "/images/platforms/xbmc.png";
            case "Safari":
                return "/images/platforms/safari.png";
            case "Internet Explorer":
                return "/images/platforms/ie.png";
            case "Microsoft Edge":
                return "/images/platforms/msedge.png";
            case "Unknown Browser":
                return "/images/platforms/dafault.png";
            case "Windows-XBMC":
                return "/images/platforms/xbmc.png";
            case "Xbox":
                return "/images/platforms/xbox.png";
            case "Samsung":
                return "/images/platforms/samsung.png";
            case "Opera":
                return "/images/platforms/opera.png";
            case "KODI":
                return "/images/platforms/kodi.png";
            case "Playstation 3":
                return "/images/platforms/playstation.png";
            case "Playstation 4":
                return "/images/platforms/playstation.png";
            case "Xbox 360":
                return "/images/platforms/xbox.png";
            case "Windows":
                return "/images/platforms/win8.png";
            case "Windows phone":
                return "/images/platforms/wp.png";
            case "Plex Media Player":
                return "/images/platforms/pmp.png";

            default:
                return "/images/platforms/default.png";
        }
    }
}
