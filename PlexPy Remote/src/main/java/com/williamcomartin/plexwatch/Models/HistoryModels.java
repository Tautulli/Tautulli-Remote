package com.williamcomartin.plexwatch.Models;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by wcomartin on 2015-12-03.
 */
public class HistoryModels {

    public class Data {
        public List<History> data = new ArrayList<>();
        public Integer draw;
        public Integer recordsFiltered;
        public Integer recordsTotal;
    }

    public class History {
        public String audioDecision;
        public Integer date;
        public Integer duration;
        public String friendlyName;
        public String fullTitle;
        public Integer grandparentRatingKey;
        public Integer groupCount;
        public String groupIds;
        public Integer id;
        public String ipAddress;
        public Integer mediaIndex;
        public String mediaType;
        public Integer parentMediaIndex;
        public Integer parentRatingKey;
        public String parentTitle;
        public Integer pausedCounter;
        public Integer percentComplete;
        public String platform;
        public String player;
        public Integer ratingKey;
        public Integer referenceId;
        public Integer started;
        public Integer stopped;
        public String thumb;
        public String user;
        public Integer userId;
        public String videoDecision;
        public Integer watchedStatus;
        public Integer year;
    }

    public class HistoryResponse {
        public Response response;
    }

    public class Response {
        public Data data;
        public String message;
        public String result;
    }
}
