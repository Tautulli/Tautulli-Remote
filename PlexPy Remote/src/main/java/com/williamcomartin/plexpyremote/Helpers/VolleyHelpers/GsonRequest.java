package com.williamcomartin.plexpyremote.Helpers.VolleyHelpers;

import com.android.volley.AuthFailureError;
import com.android.volley.NetworkResponse;
import com.android.volley.ParseError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.RetryPolicy;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.HttpHeaderParser;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSyntaxException;
import com.williamcomartin.plexpyremote.Helpers.GSONTypeAdapters;

import java.io.UnsupportedEncodingException;
import java.util.Map;

/**
 * Created by wcomartin on 2015-11-30.
 */
public class GsonRequest<T> extends Request<T> {

    private Gson gson;
    private final Class<T> clazz;
    private final Map<String, String> headers;
    private final Response.Listener<T> listener;


    public GsonRequest(String url, Class<T> clazz, Map<String, String> headers,
                       Response.Listener<T> listener, Response.ErrorListener errorListener) {
        super(Method.GET, url, errorListener);

        GsonBuilder gsonB = new GsonBuilder();
        gsonB.registerTypeAdapter(Double.class, GSONTypeAdapters.DoubleTypeAdapter);
        gsonB.registerTypeAdapter(Integer.class, GSONTypeAdapters.IntegerTypeAdapter);
        gsonB.registerTypeAdapter(Long.class, GSONTypeAdapters.LongTypeAdapter);
        gson = gsonB.create();

        this.clazz = clazz;
        this.headers = headers;
        this.listener = listener;
    }

    @Override
    public Map<String, String> getHeaders() throws AuthFailureError {
        return headers != null ? headers : super.getHeaders();
    }

    @Override
    protected void deliverResponse(T response) {
        listener.onResponse(response);
    }

    @Override
    protected Response<T> parseNetworkResponse(NetworkResponse response) {
        try {
            String json = new String(response.data, HttpHeaderParser.parseCharset(response.headers));
            return Response.success(gson.fromJson(json, clazz),
                    HttpHeaderParser.parseCacheHeaders(response));
        } catch (UnsupportedEncodingException e) {
            return Response.error(new ParseError(e));
        } catch (JsonSyntaxException e) {
            return Response.error(new ParseError(e));
        }
    }
}
