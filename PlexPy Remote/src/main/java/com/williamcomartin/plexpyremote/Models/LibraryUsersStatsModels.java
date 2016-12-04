package com.williamcomartin.plexpyremote.Models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by wcomartin on 16-05-17.
 */
public class LibraryUsersStatsModels {

    public Response response;

    public class Response {
        public Object message;
        public List<LibraryUsersStat> data = new ArrayList<LibraryUsersStat>();
        public String result;
    }

    public class LibraryUsersStat {
        @SerializedName("user_id")
        @Expose
        public Integer userId;
        @SerializedName("friendly_name")
        @Expose
        public String friendlyName;
        @SerializedName("total_plays")
        @Expose
        public Integer totalPlays;
        @SerializedName("user_thumb")
        @Expose
        public String userThumb;
    }
}
