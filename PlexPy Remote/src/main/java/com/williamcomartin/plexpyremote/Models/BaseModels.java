package com.williamcomartin.plexpyremote.Models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by wcomartin on 2016-12-14.
 */

public class BaseModels<T> {

    public Response response;

    public class Response {
        @SerializedName("message")
        public Object message;

        @SerializedName("data")
        public T data;

        @SerializedName("result")
        public String result;
    }
}
