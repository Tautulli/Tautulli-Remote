package com.williamcomartin.plexpyremote.Helpers.VolleyHelpers;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.ImageLoader.ImageCache;
import com.android.volley.toolbox.ImageLoader.ImageListener;

/**
 * Created by wcomartin on 2016-12-21.
 */
public class ImageCacheManager{

    private static ImageCacheManager mInstance;

    private ImageLoader mImageLoader;

    private ImageCache mImageCache;

    public static ImageCacheManager getInstance(){
        if(mInstance == null)
            mInstance = new ImageCacheManager();

        return mInstance;
    }

    public void init(Context context, String uniqueName, int cacheSize, CompressFormat compressFormat, int quality){
        mImageCache= new DiskLruImageCache(context, uniqueName, cacheSize, compressFormat, quality);

        mImageLoader = new ImageLoader(RequestManager.getRequestQueue(), mImageCache);
    }

    public Bitmap getBitmap(String url) {
        try {
            return mImageCache.getBitmap(createKey(url));
        } catch (NullPointerException e) {
            throw new IllegalStateException("Disk Cache Not initialized");
        }
    }

    public void putBitmap(String url, Bitmap bitmap) {
        try {
            mImageCache.putBitmap(createKey(url), bitmap);
        } catch (NullPointerException e) {
            throw new IllegalStateException("Disk Cache Not initialized");
        }
    }


    public void getImage(String url, ImageListener listener){
        mImageLoader.get(url, listener);
    }

    public ImageLoader getImageLoader() {
        return mImageLoader;
    }

    private String createKey(String url){
        return String.valueOf(url.hashCode());
    }


}