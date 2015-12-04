package com.williamcomartin.plexwatch.Models;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by wcomartin on 2015-11-20.
 */
public class UserModels {
    public class UserResponse {
        public Response response;
    }

    public class Response {
        public Data data;
        public Object message;
        public String result;
    }

    public class Data {
        public List<User> data = new ArrayList<>();
        public Integer draw;
        public Integer records_filtered;
        public Integer records_total;
    }

    public class User {
        public String do_notify;
        public String friendly_name;
        public Integer id;
        public String ip_address;
        public String keep_history;
        public Integer last_seen;
        public String last_watched;
        public String media_type;
        public String platform;
        public String player;
        public Integer plays;
        public Integer rating_key;
        public String thumb;
        public String user;
        public Integer user_id;
        public String user_thumb;
        public String video_decision;
    }
}
