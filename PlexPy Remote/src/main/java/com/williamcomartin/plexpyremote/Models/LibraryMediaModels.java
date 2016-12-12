package com.williamcomartin.plexpyremote.Models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by wcomartin on 2016-12-11.
 */

public class LibraryMediaModels {

    public LibraryMediaModels.Response response;

    public class Response {
        public Object message;
        public Data data;
        public String result;
    }

    public class Data {

        @SerializedName("draw")
        @Expose
        public Integer draw;
        @SerializedName("recordsTotal")
        @Expose
        public Integer recordsTotal;
        @SerializedName("total_file_size")
        @Expose
        public Integer totalFileSize;
        @SerializedName("recordsFiltered")
        @Expose
        public Integer recordsFiltered;
        @SerializedName("filtered_file_size")
        @Expose
        public Integer filteredFileSize;
        @SerializedName("data")
        @Expose
        public List<LibraryMediaModels.LibraryMediaItem> data = new ArrayList<>();

    }

    public class LibraryMediaItem {

        @SerializedName("year")
        @Expose
        public String year;
        @SerializedName("parent_rating_key")
        @Expose
        public String parentRatingKey;
        @SerializedName("audio_codec")
        @Expose
        public String audioCodec;
        @SerializedName("file_size")
        @Expose
        public Long fileSize;
        @SerializedName("rating_key")
        @Expose
        public String ratingKey;
        @SerializedName("container")
        @Expose
        public String container;
        @SerializedName("thumb")
        @Expose
        public String thumb;
        @SerializedName("title")
        @Expose
        public String title;
        @SerializedName("section_type")
        @Expose
        public String sectionType;
        @SerializedName("media_type")
        @Expose
        public String mediaType;
        @SerializedName("video_resolution")
        @Expose
        public String videoResolution;
        @SerializedName("grandparent_rating_key")
        @Expose
        public String grandparentRatingKey;
        @SerializedName("audio_channels")
        @Expose
        public String audioChannels;
        @SerializedName("last_played")
        @Expose
        public Long lastPlayed;
        @SerializedName("section_id")
        @Expose
        public Integer sectionId;
        @SerializedName("play_count")
        @Expose
        public Integer playCount;
        @SerializedName("bitrate")
        @Expose
        public String bitrate;
        @SerializedName("video_framerate")
        @Expose
        public String videoFramerate;
        @SerializedName("media_index")
        @Expose
        public String mediaIndex;
        @SerializedName("added_at")
        @Expose
        public String addedAt;
        @SerializedName("video_codec")
        @Expose
        public String videoCodec;
        @SerializedName("parent_media_index")
        @Expose
        public String parentMediaIndex;

    }

}
