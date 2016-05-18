package com.williamcomartin.plexwatch.Models;

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
        @Expose
        public Object message;
        @SerializedName("data")
        @Expose
        public Data data;
        @SerializedName("result")
        @Expose
        public String result;

    }

    public class Data {
        @SerializedName("draw")
        @Expose
        public Integer draw;
        @SerializedName("total_duration")
        @Expose
        public String totalDuration;
        @SerializedName("recordsTotal")
        @Expose
        public Integer recordsTotal;
        @SerializedName("recordsFiltered")
        @Expose
        public Integer recordsFiltered;
        @SerializedName("data")
        @Expose
        public List<HistoryRecord> data = new ArrayList<HistoryRecord>();
        @SerializedName("filter_duration")
        @Expose
        public String filterDuration;
    }

    public class HistoryRecord {

        @SerializedName("parent_title")
        @Expose
        public String parentTitle;
        @SerializedName("paused_counter")
        @Expose
        public Integer pausedCounter;
        @SerializedName("player")
        @Expose
        public String player;
        @SerializedName("parent_rating_key")
        @Expose
        public Integer parentRatingKey;
        @SerializedName("year")
        @Expose
        public Integer year;
        @SerializedName("duration")
        @Expose
        public Integer duration;
        @SerializedName("transcode_decision")
        @Expose
        public String transcodeDecision;
        @SerializedName("rating_key")
        @Expose
        public Integer ratingKey;
        @SerializedName("user_id")
        @Expose
        public Integer userId;
        @SerializedName("thumb")
        @Expose
        public String thumb;
        @SerializedName("id")
        @Expose
        public Integer id;
        @SerializedName("platform")
        @Expose
        public String platform;
        @SerializedName("media_type")
        @Expose
        public String mediaType;
        @SerializedName("grandparent_rating_key")
        @Expose
        public Integer grandparentRatingKey;
        @SerializedName("started")
        @Expose
        public Integer started;
        @SerializedName("full_title")
        @Expose
        public String fullTitle;
        @SerializedName("reference_id")
        @Expose
        public Integer referenceId;
        @SerializedName("date")
        @Expose
        public Long date;
        @SerializedName("percent_complete")
        @Expose
        public Integer percentComplete;
        @SerializedName("ip_address")
        @Expose
        public String ipAddress;
        @SerializedName("group_ids")
        @Expose
        public String groupIds;
        @SerializedName("media_index")
        @Expose
        public Integer mediaIndex;
        @SerializedName("friendly_name")
        @Expose
        public String friendlyName;
        @SerializedName("watched_status")
        @Expose
        public Integer watchedStatus;
        @SerializedName("group_count")
        @Expose
        public Integer groupCount;
        @SerializedName("stopped")
        @Expose
        public Integer stopped;
        @SerializedName("parent_media_index")
        @Expose
        public Integer parentMediaIndex;
        @SerializedName("user")
        @Expose
        public String user;

    }

}
