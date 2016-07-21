package com.williamcomartin.plexpyremote.Services;

/**
 * Created by wcomartin on 16-05-20.
 */
public class NavService {
    public static NavService mInstance;

    public int currentNav;

    public static NavService getInstance() {
        if (mInstance == null) {
            Class clazz = NavService.class;
            synchronized (clazz) {
                mInstance = new NavService();
            }
        }
        return mInstance;
    }
}
