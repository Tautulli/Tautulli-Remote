package com.williamcomartin.plexpyremote.Models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by wcomartin on 16-05-26.
 */
public class UserWatchStatsModels {
    public Response response;

    public class Response {
        public List<WatchStat> data = new ArrayList<WatchStat>();
        public Object message;
        public String result;
    }

    public class WatchStat {
        @SerializedName("query_days")
        @Expose
        public Integer queryDays;
        @SerializedName("total_time")
        @Expose
        public Long totalTime;
        @SerializedName("total_plays")
        @Expose
        public Integer totalPlays;
    }
}
