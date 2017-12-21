package com.williamcomartin.plexpyremote.Services;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.support.annotation.RequiresApi;
import android.support.v4.content.ContextCompat;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.util.Log;

import com.williamcomartin.plexpyremote.R;

/**
 * Created by wcomartin on 16-05-22.
 */
public class PlatformService {

    public static Bitmap getBitmapFromVectorDrawable(Context context, int drawableId, int color) {
        Drawable drawable = ContextCompat.getDrawable(context, drawableId);
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            drawable = (DrawableCompat.wrap(drawable)).mutate();
        }

        Bitmap bitmap = Bitmap.createBitmap(drawable.getIntrinsicWidth(),
                drawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(bitmap);

        canvas.drawColor(context.getResources().getColor(color));

        int padding = 25;
        drawable.setBounds(padding, padding, canvas.getWidth() - padding, canvas.getHeight() - padding);
        drawable.draw(canvas);

        return bitmap;
    }

    public static int getPlatformColor(String platformName) {
        switch (platformName.toLowerCase()) {
            case "android":
                return R.color.platform_android;
            case "atv":
                return R.color.platform_atv;
            case "chrome":
                return R.color.platform_chrome;
            case "chromecast":
                return R.color.platform_chromecast;
            case "dlna":
                return R.color.platform_dlna;
            case "firefox":
                return R.color.platform_firefox;
            case "ie":
                return R.color.platform_ie;
            case "ios":
                return R.color.platform_ios;
            case "kodi":
                return R.color.platform_kodi;
            case "linux":
                return R.color.platform_linux;
            case "macos":
                return R.color.platform_macos;
            case "msedge":
                return R.color.platform_msedge;
            case "opera":
                return R.color.platform_opera;
            case "playstation":
                return R.color.platform_playstation;
            case "plex":
                return R.color.platform_plex;
            case "plexamp":
                return R.color.platform_plexamp;
            case "synclounge":
                return R.color.platform_synclounge;
            case "roku":
                return R.color.platform_roku;
            case "safari":
                return R.color.platform_safari;
            case "samsung":
                return R.color.platform_samsung;
            case "windows":
                return R.color.platform_windows;
            case "wiiu":
                return R.color.platform_wiiu;
            case "xbox":
                return R.color.platform_xbox;
            case "tivo":
                return R.color.platform_tivo;

            default:
                return R.color.platform_default;
        }
    }

    public static int getPlatformImagePath(String platformName) {
        if(platformName == null) return R.drawable.platform_default;
        switch(platformName.toLowerCase()) {
            case "android":
                return R.drawable.platform_android;
            case "atv":
                return R.drawable.platform_atv;
            case "chrome":
                return R.drawable.platform_chrome;
            case "chromecast":
                return R.drawable.platform_chromecast;
            case "dlna":
                return R.drawable.platform_dlna;
            case "firefox":
                return R.drawable.platform_firefox;
            case "ie":
                return R.drawable.platform_ie;
            case "ios":
                return R.drawable.platform_ios;
            case "kodi":
                return R.drawable.platform_kodi;
            case "linux":
                return R.drawable.platform_linux;
            case "macos":
                return R.drawable.platform_macos;
            case "msedge":
                return R.drawable.platform_msedge;
            case "opera":
                return R.drawable.platform_opera;
            case "playstation":
                return R.drawable.platform_playstation;
            case "plex":
                return R.drawable.platform_plex;
            case "plexamp":
                return R.drawable.platform_plexamp;
            case "synclounge":
                return R.drawable.platform_synclounge;
            case "roku":
                return R.drawable.platform_roku;
            case "safari":
                return R.drawable.platform_safari;
            case "samsung":
                return R.drawable.platform_samsung;
            case "windows":
                return R.drawable.platform_windows;
            case "wiiu":
                return R.drawable.platform_wiiu;
            case "xbox":
                return R.drawable.platform_xbox;
            case "tivo":
                return R.drawable.platform_tivo;

            default:
                return R.drawable.platform_default;
        }
    }
}
