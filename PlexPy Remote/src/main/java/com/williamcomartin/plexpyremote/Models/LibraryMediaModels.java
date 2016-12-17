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
        public Integer draw;
        @SerializedName("recordsTotal")
        public Integer recordsTotal;
        @SerializedName("total_file_size")
        public Integer totalFileSize;
        @SerializedName("recordsFiltered")
        public Integer recordsFiltered;
        @SerializedName("filtered_file_size")
        public Integer filteredFileSize;
        @SerializedName("data")
        public List<LibraryMediaModels.LibraryMediaItem> data = new ArrayList<>();

    }

    public class LibraryMediaItem {

        @SerializedName("year")
        public String year;

        @SerializedName("parent_rating_key")
        public String parentRatingKey;

        @SerializedName("audio_codec")
        public String audioCodec;

        @SerializedName("file_size")
        public Long fileSize;

        @SerializedName("rating_key")
        public String ratingKey;

        @SerializedName("container")
        public String container;

        @SerializedName("thumb")
        public String thumb;

        @SerializedName("title")
        public String title;

        @SerializedName("section_type")
        public String sectionType;

        @SerializedName("media_type")
        public String mediaType;

        @SerializedName("video_resolution")
        public String videoResolution;

        @SerializedName("grandparent_rating_key")
        public String grandparentRatingKey;

        @SerializedName("audio_channels")
        public String audioChannels;

        @SerializedName("last_played")
        public Long lastPlayed;

        @SerializedName("section_id")
        public Integer sectionId;

        @SerializedName("play_count")
        public Integer playCount;

        @SerializedName("bitrate")
        public String bitrate;

        @SerializedName("video_framerate")
        public String videoFramerate;

        @SerializedName("media_index")
        public String mediaIndex;

        @SerializedName("added_at")
        public String addedAt;

        @SerializedName("video_codec")
        public String videoCodec;

        @SerializedName("parent_media_index")
        public String parentMediaIndex;

    }

}
