package com.williamcomartin.plexpyremote.Models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by wcomartin on 2015-12-03.
 */
public class HistoryModels {

    public Response response;

    public class Response {

        @SerializedName("message")
        public Object message;
        @SerializedName("data")
        public Data data;
        @SerializedName("result")
        public String result;

    }

    public class Data {
        @SerializedName("draw")
        public Integer draw;
        @SerializedName("total_duration")
        public String totalDuration;
        @SerializedName("recordsTotal")
        public Integer recordsTotal;
        @SerializedName("recordsFiltered")
        public Integer recordsFiltered;
        @SerializedName("data")
        public List<HistoryRecord> data = new ArrayList<HistoryRecord>();
        @SerializedName("filter_duration")
        public String filterDuration;
    }

    public class HistoryRecord {

        @SerializedName("parent_title")
        public String parentTitle;
        @SerializedName("paused_counter")
        public Long pausedCounter;
        @SerializedName("player")
        public String player;
        @SerializedName("parent_rating_key")
        public Integer parentRatingKey;
        @SerializedName("year")
        public Integer year;
        @SerializedName("duration")
        public Long duration;
        @SerializedName("transcode_decision")
        public String transcodeDecision;
        @SerializedName("rating_key")
        public Integer ratingKey;
        @SerializedName("user_id")
        public Integer userId;
        @SerializedName("thumb")
        public String thumb;
        @SerializedName("id")
        public Integer id;
        @SerializedName("platform")
        public String platform;
        @SerializedName("media_type")
        public String mediaType;
        @SerializedName("grandparent_rating_key")
        public Integer grandparentRatingKey;
        @SerializedName("started")
        public Long started;
        @SerializedName("full_title")
        public String fullTitle;
        @SerializedName("reference_id")
        public Integer referenceId;
        @SerializedName("date")
        public Long date;
        @SerializedName("percent_complete")
        public Integer percentComplete;
        @SerializedName("ip_address")
        public String ipAddress;
        @SerializedName("group_ids")
        public String groupIds;
        @SerializedName("media_index")
        public Integer mediaIndex;
        @SerializedName("friendly_name")
        public String friendlyName;
        @SerializedName("watched_status")
        public Integer watchedStatus;
        @SerializedName("group_count")
        public Integer groupCount;
        @SerializedName("state")
        public String state;
        @SerializedName("stopped")
        public Long stopped;
        @SerializedName("parent_media_index")
        public Integer parentMediaIndex;
        @SerializedName("user")
        public String user;

        public Boolean detailsOpen = false;
    }

}
