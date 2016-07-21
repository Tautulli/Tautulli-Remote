package com.williamcomartin.plexpyremote.Models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by wcomartin on 16-05-26.
 */
public class UserPlayerStatsModels {
    public Response response;

    public class Response {
        public List<PlayerStat> data = new ArrayList<PlayerStat>();
        public Object message;
        public String result;
    }

    public class PlayerStat {
        @SerializedName("platform_type")
        @Expose
        public Integer platformType;
        @SerializedName("player_name")
        @Expose
        public Long playerName;
        @SerializedName("total_plays")
        @Expose
        public Integer totalPlays;
        @SerializedName("result_id")
        @Expose
        public Integer resultId;
    }
}
