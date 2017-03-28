package com.williamcomartin.plexpyremote.Models;

import com.google.gson.annotations.SerializedName;

/**
 * Created by wcomartin on 2016-12-14.
 */

public class NoDataModels {

    public Response response;

    public class Response {
        @SerializedName("message")
        public Object message;

        @SerializedName("result")
        public String result;
    }
}
