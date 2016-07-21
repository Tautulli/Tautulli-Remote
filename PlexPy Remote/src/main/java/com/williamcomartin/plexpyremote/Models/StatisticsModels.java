package com.williamcomartin.plexpyremote.Models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by wcomartin on 2015-11-04.
 */
public class StatisticsModels {

    public Response response;

    public class Response {
        public Object message;
        public List<StatisticsGroup> data = new ArrayList<>();
        public String result;

        public StatisticsGroup FindStat(String statId) {
            for(StatisticsGroup dataItem : data){
                if(dataItem.statId.equals(statId)){
                    return dataItem;
                }
            }
            return null;
        }
    }

    public class StatisticsGroup {
        @SerializedName("stat_id")
        @Expose
        public String statId;
        public List<StatisticsRow> rows = new ArrayList<StatisticsRow>();
        @SerializedName("stat_type")
        @Expose
        public String statType;
    }

    public class StatisticsRow {
        public String content_rating;
        public String platform;
        public String thumb;
        public String users_watched;
        public String title;
        public Integer row_id;
        public List<String> labels = new ArrayList<>();
        public Integer total_duration;
        public String friendly_name;
        public Integer section_id;
        public Integer last_play;
        public Long last_watch;
        public String platform_type;
        public Integer total_plays;
        public String media_type;
        public String grandparent_thumb;
        public String user_thumb;
        public Integer rating_key;
        public String user;
        public String player;
    }

}
