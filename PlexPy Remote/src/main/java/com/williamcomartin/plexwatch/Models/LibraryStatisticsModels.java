package com.williamcomartin.plexwatch.Models;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by wcomartin on 16-05-17.
 */
public class LibraryStatisticsModels {

    public Response response;

    public class Response {
        public Object message;
        public List<LibraryStat> data = new ArrayList<LibraryStat>();
        public String result;
    }

    public class LibraryStat {
        public String count;
        public String art;
        public String thumb;
        @SerializedName("section_type")
        @Expose
        public String sectionType;
        @SerializedName("section_id")
        @Expose
        public String sectionId;
        @SerializedName("section_name")
        @Expose
        public String sectionName;
        @SerializedName("parent_count")
        @Expose
        public String parentCount;
        @SerializedName("child_count")
        @Expose
        public String childCount;
    }
}
