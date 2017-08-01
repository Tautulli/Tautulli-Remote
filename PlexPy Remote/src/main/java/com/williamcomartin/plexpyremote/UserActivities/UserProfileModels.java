package com.williamcomartin.plexpyremote.UserActivities;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by wcomartin on 2017-07-15.
 */

public class UserProfileModels {
    public UserProfileModels.Response response;

    public class Response {
        public UserProfileModels.Data data;
        public Object message;
        public String result;
    }

    public class Data {
        public Integer recordsFiltered;
        public Integer recordsTotal;
        public Integer draw;
        public List<UserProfileModels.User> data = new ArrayList<UserProfileModels.User>();
    }

    public class User {
        @SerializedName("user_thumb")
        @Expose
        public String userThumb;
        @SerializedName("parent_title")
        @Expose
        public String parentTitle;
        @SerializedName("player")
        @Expose
        public String player;
        @SerializedName("year")
        @Expose
        public Integer year;
        @SerializedName("duration")
        @Expose
        public Integer duration;
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
        @SerializedName("do_notify")
        @Expose
        public String doNotify;
        @SerializedName("allow_guest")
        @Expose
        public String allowGuest;
        @SerializedName("last_played")
        @Expose
        public String lastPlayed;
        @SerializedName("transcode_decision")
        @Expose
        public String transcodeDecision;
        @SerializedName("plays")
        @Expose
        public Integer plays;
        @SerializedName("ip_address")
        @Expose
        public String ipAddress;
        @SerializedName("media_index")
        @Expose
        public Integer mediaIndex;
        @SerializedName("friendly_name")
        @Expose
        public String friendlyName;
        @SerializedName("keep_history")
        @Expose
        public String keepHistory;
        @SerializedName("parent_media_index")
        @Expose
        public Integer parentMediaIndex;
        @SerializedName("last_seen")
        @Expose
        public Integer lastSeen;
    }
}
