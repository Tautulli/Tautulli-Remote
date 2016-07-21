package com.williamcomartin.plexpyremote.Models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by wcomartin on 16-05-17.
 */
public class RecentlyAddedModels {

    public Response response;

    public class Response {
        public Object message;
        public Data data;
        public String result;
    }

    public class Data {
        @SerializedName("recently_added")
        @Expose
        public List<RecentItem> recentlyAdded = new ArrayList<>();
    }

    public class RecentItem {
        @SerializedName("added_at")
        @Expose
        public String addedAt;
        @SerializedName("grandparent_rating_key")
        @Expose
        public String grandparentRatingKey;
        @SerializedName("grandparent_thumb")
        @Expose
        public String grandparentThumb;
        @SerializedName("grandparent_title")
        @Expose
        public String grandparentTitle;
        @SerializedName("library_name")
        @Expose
        public String libraryName;
        @SerializedName("media_index")
        @Expose
        public String mediaIndex;
        @SerializedName("media_type")
        @Expose
        public String mediaType;
        @SerializedName("parent_media_index")
        @Expose
        public String parentMediaIndex;
        @SerializedName("parent_rating_key")
        @Expose
        public String parentRatingKey;
        @SerializedName("parent_thumb")
        @Expose
        public String parentThumb;
        @SerializedName("parent_title")
        @Expose
        public String parentTitle;
        @SerializedName("rating_key")
        @Expose
        public String ratingKey;
        @SerializedName("section_id")
        @Expose
        public String sectionId;
        @SerializedName("thumb")
        @Expose
        public String thumb;
        @SerializedName("title")
        @Expose
        public String title;
        @SerializedName("year")
        @Expose
        public String year;
    }

}
