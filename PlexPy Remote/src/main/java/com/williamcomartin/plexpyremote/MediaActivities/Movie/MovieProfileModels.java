package com.williamcomartin.plexpyremote.MediaActivities.Movie;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by wcomartin on 2016-12-14.
 */

public class MovieProfileModels {

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

        @SerializedName("metadata")
        public Data metadata;

        @SerializedName("library_name")
        public String libraryName;

        @SerializedName("last_viewed_at")
        public String lastViewedAt;

        @SerializedName("art")
        public String art;

        @SerializedName("rating")
        public String rating;

        @SerializedName("year")
        public String year;

        @SerializedName("section_id")
        public String sectionId;

        @SerializedName("updated_at")
        public String updatedAt;

        @SerializedName("studio")
        public String studio;

        @SerializedName("parent_rating_key")
        public String parentRatingKey;

        @SerializedName("parent_title")
        public String parentTitle;

        @SerializedName("duration")
        public String duration;

        @SerializedName("guid")
        public String guid;

        @SerializedName("rating_key")
        public String ratingKey;

        @SerializedName("originally_available_at")
        public String originallyAvailableAt;

        @SerializedName("genres")
        public List<String> genres = null;

        @SerializedName("thumb")
        public String thumb;

        @SerializedName("media_index")
        public String mediaIndex;

        @SerializedName("title")
        public String title;

        @SerializedName("tagline")
        public String tagline;

        @SerializedName("content_rating")
        public String contentRating;

        @SerializedName("actors")
        public List<String> actors = null;

        @SerializedName("added_at")
        public String addedAt;

        @SerializedName("summary")
        public String summary;

        @SerializedName("labels")
        public List<String> labels = null;

        @SerializedName("directors")
        public List<String> directors = null;

        @SerializedName("writers")
        public List<String> writers = null;

        @SerializedName("grandparent_thumb")
        public String grandparentThumb;

        @SerializedName("parent_thumb")
        public String parentThumb;

        @SerializedName("grandparent_title")
        public String grandparentTitle;

        @SerializedName("media_type")
        public String mediaType;

        @SerializedName("parent_media_index")
        public String parentMediaIndex;

        @SerializedName("grandparent_rating_key")
        public String grandparentRatingKey;
    }
}
