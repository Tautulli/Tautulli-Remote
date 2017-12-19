package com.williamcomartin.plexpyremote.Helpers;

import android.content.Context;
import android.util.Log;

import com.android.volley.Response;
import com.android.volley.VolleyError;

/**
 * Created by wcomartin on 2016-11-18.
 */

public class ErrorListener implements Response.ErrorListener {

    private Context context;

    public ErrorListener(Context context){
        this.context = context;
    }

    @Override
    public void onErrorResponse(VolleyError error) {
//        Log.d("ErrorListener", error.getMessage());
    }
}
