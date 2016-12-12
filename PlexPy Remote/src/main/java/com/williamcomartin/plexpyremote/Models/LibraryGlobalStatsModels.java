package com.williamcomartin.plexpyremote.Models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by wcomartin on 16-05-17.
 */
public class LibraryGlobalStatsModels {

    public Response response;

    public class Response {
        public Object message;
        public List<LibraryGlobalStat> data = new ArrayList<LibraryGlobalStat>();
        public String result;
    }

    public class LibraryGlobalStat {
        @SerializedName("query_days")
        @Expose
        public Integer queryDays;
        @SerializedName("total_time")
        @Expose
        public Integer totalTime;
        @SerializedName("total_plays")
        @Expose
        public Integer totalPlays;
    }
}
