package com.williamcomartin.plexwatch.Models;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by wcomartin on 2015-11-21.
 */
public class ActivityModels {

    public class ResponseParent {
        public Response response;
        public Map<String, Object> additionalProperties = new HashMap<>();
    }

    public class Response {
        public Activity[] data;
    }

    public class Activity {
        public String art;
        public String aspect_ratio;
        public String audio_channels;
        public String audio_codec;
        public String audio_decision;
        public String bif_thumb;
        public String bitrate;
        public String container;
        public String duration;
        public String friendly_name;
        public String grandparent_rating_key;
        public String grandparent_thumb;
        public String grandparent_title;
        public String height;
        public int indexes;
        public String machine_id;
        public String media_index;
        public String media_type;
        public String parent_media_index;
        public String parent_rating_key;
        public String parent_thumb;
        public String parent_title;
        public String platform;
        public String player;
        public String progress_percent;
        public String rating_key;
        public String session_key;
        public String state;
        public String throttled;
        public String thumb;
        public String title;
        public String transcode_audio_channels;
        public String transcode_audio_codec;
        public String transcode_container;
        public String transcode_height;
        public String transcode_progress;
        public String transcode_protocol;
        public String transcode_speed;
        public String transcode_video_codec;
        public String transcode_width;
        public String user;
        public int user_id;
        public String user_thumb;
        public String video_codec;
        public String video_decision;
        public String video_framerate;
        public String video_resolution;
        public String view_offset;
        public String width;
        public String year;
    }
}
