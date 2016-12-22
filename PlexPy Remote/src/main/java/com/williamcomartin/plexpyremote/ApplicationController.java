package com.williamcomartin.plexpyremote;

import android.app.Application;
import android.graphics.Bitmap;
import android.text.TextUtils;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.Volley;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.DiskLruImageCache;
import com.williamcomartin.plexpyremote.Helpers.NukeSSLCerts;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.ImageCacheManager;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;

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
    }

    public static synchronized ApplicationController getInstance() {
        return mInstance;
    }
}
