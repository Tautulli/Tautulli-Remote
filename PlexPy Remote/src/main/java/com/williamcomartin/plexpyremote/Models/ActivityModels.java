package com.williamcomartin.plexpyremote.Models;

import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

/**
 * Created by wcomartin on 2015-11-21.
 */
public class ActivityModels {

    public Response response;

    public class Response {
        public Object message;
        public Data data;
        public String result;
    }

    public class Data {
        public String stream_count;
        public List<Activity> sessions = new ArrayList<>();
    }

    public class Activity {
        public String rating;
        public String transcode_width;
        public List<String> labels = null;
        public String stream_bitrate;
        public String bandwidth;
        public Integer optimized_version;
        public String audio_bitrate_mode;
        public String parent_rating_key;
        public String rating_key;
        public String platform_version;
        public Integer transcode_hw_decoding;
        public String thumb;
        public String title;
        public String video_codec_level;
        public String tagline;
        public String last_viewed_at;
        public String audio_sample_rate;
        public String user_rating;
        public String platform;
        public String stream_video_ref_frames;
        public String location;
        public String transcode_container;
        public String audio_channel_layout;
        public String local;
        public String transcode_hw_encode_title;
        public String stream_container_decision;
        public String audience_rating;
        public String full_title;
        public String ip_address;
        public Integer subtitles;
        public String stream_subtitle_language;
        public Integer channel_stream;
        public String video_bitrate;
        public Integer is_allow_sync;
        public String stream_video_bitrate;
        public String summary;
        public String stream_audio_decision;
        public String aspect_ratio;
        public String video_language;
        public String transcode_hw_decode_title;
        public String stream_audio_channel_layout;
        public Integer deleted_user;
        public String library_name;
        public String art;
        public String stream_audio_language_code;
        public String video_profile;
        public String sort_title;
        public String stream_video_codec_level;
        public String stream_video_height;
        public String year;
        public String stream_duration;
        public String stream_audio_channels;
        public String video_language_code;
        public String transcode_key;
        public Integer transcode_throttled;
        public String container;
        public String stream_audio_bitrate;
        public String user;
        public String progress_percent;
        public String subtitle_location;
        public Integer transcode_hw_requested;
        public String video_height;
        public String state;
        public Integer is_restricted;
        public String stream_subtitle_decision;
        public String stream_audio_language;
        public String stream_container;
        public String transcode_speed;
        public String video_bit_depth;
        public String grandparent_title;
        public String studio;
        public String transcode_decision;
        public String video_width;
        public String bitrate;
        public String machine_id;
        public String originally_available_at;
        public String video_frame_rate;
        public String synced_version_profile;
        public String friendly_name;
        public String audio_profile;
        public String optimized_version_title;
        public String platform_name;
        public String stream_video_language;
        public Integer keep_history;
        public String stream_audio_codec;
        public String stream_video_codec;
        public String grandparent_thumb;
        public Integer is_home_user;
        public Integer synced_version;
        public String transcode_hw_decode;
        public String user_thumb;
        public String stream_video_width;
        public String height;
        public String email;
        public String audio_codec;
        public String parent_title;
        public String guid;
        public String audio_language_code;
        public String transcode_video_codec;
        public String transcode_audio_codec;
        public String stream_video_decision;
        public Integer user_id;
        public String transcode_height;
        public Integer transcode_hw_full_pipeline;
        public String throttled;
        public String width;
        public String quality_profile;
        public Integer stream_subtitle_forced;
        public String media_type;
        public String video_resolution;
        public String stream_subtitle_location;
        public Integer do_notify;
        public String video_ref_frames;
        public String audio_channels;
        public String optimized_version_profile;
        public String duration;
        public String stream_audio_sample_rate;
        public String stream_video_resolution;
        public String ip_address_public;
        public Integer allow_guest;
        public String transcode_audio_channels;
        public String media_index;
        public String stream_video_framerate;
        public String transcode_hw_encode;
        public String grandparent_rating_key;
        public String added_at;
        public String banner;
        public String bif_thumb;
        public String parent_media_index;
        public String audio_language;
        public String stream_audio_bitrate_mode;
        public String username;
        public String subtitle_decision;
        public String product_version;
        public String updated_at;
        public String player;
        public String subtitle_format;
        public String file;
        public String file_size;
        public String session_key;
        public String id;
        public String subtitle_container;
        public List<String> genres = null;
        public String stream_video_language_code;
        public Integer indexes;
        public String video_decision;
        public String stream_subtitle_language_code;
        public List<String> writers = null;
        public List<String> actors = null;
        public String stream_subtitle_format;
        public String audio_decision;
        public Integer subtitle_forced;
        public String profile;
        public String product;
        public String view_offset;
        public String type;
        public String audio_bitrate;
        public String section_id;
        public String stream_subtitle_codec;
        public String subtitle_codec;
        public String video_codec;
        public String device;
        public String stream_video_bit_depth;
        public String video_framerate;
        public Integer transcode_hw_encoding;
        public String transcode_protocol;
        public List<String> shared_libraries = null;
        public String stream_aspect_ratio;
        public String content_rating;
        public String session_id;
        public List<String> directors = null;
        public String parent_thumb;
        public String subtitle_language_code;
        public String transcode_progress;
        public String subtitle_language;
        public String stream_subtitle_container;

        public String get_bitrate() {
            float bitrate = Float.parseFloat(stream_bitrate);
            if (bitrate > 1000) {
                return String.format("%.1f", bitrate / 1000) + " Mbps";
            }
            return String.format("%.0f", bitrate) + " kbps";
        }

        public String get_stream_string() {
            if (transcode_decision.equals("transcode")) {
                String stream = "";
                stream += "Transcode";
                if (transcode_throttled == 1) {
                    stream += " (Throttled)";
                } else {
                    stream += " (Speed: " + transcode_speed + ")";
                }
                return stream;
            } else if (transcode_decision.equals("copy")) {
                return "Direct Stream";
            } else {
                return "Direct Play";
            }
        }

        public String get_container() {
            if (stream_container_decision.equals("transcode")) {
                return String.format("Transcode (%s {md-arrow-forward 18dp} %s)",
                        container.toUpperCase(),
                        stream_container.toUpperCase());
            } else {
                return String.format("Direct Play (%s)", container.toUpperCase());
            }
        }

        public String get_video_stream_string() {
            if (Arrays.asList("movie", "episode", "clip").contains(media_type)) {
                if (stream_video_decision.equals("transcode")) {
                    String hw_d = transcode_hw_decoding == 1 ? "(HW)" : "";
                    String hw_e = transcode_hw_encoding == 1 ? "(HW)" : "";
                    return String.format("Transcode (%s%s %s {md-arrow-forward 18dp} %s%s %s)",
                            video_codec.toUpperCase(), hw_d,
                            video_resolution_overrides(video_resolution),
                            stream_video_codec.toUpperCase(), hw_e,
                            video_resolution_overrides(stream_video_resolution));
                } else if(stream_video_decision.equals("copy")){
                    return String.format("Direct Stream (%s %s)", video_codec.toUpperCase(), video_resolution_overrides(video_resolution));
                } else {
                    return String.format("Direct Play (%s %s)", video_codec.toUpperCase(), video_resolution_overrides(video_resolution));
                }
            }
            return String.format("Direct Play (%sx%s)", width, height);
        }

        public String get_audio_codec_string(){
            if(stream_audio_decision.equals("transcode")){
                return String.format("Transcode (%s %s {md-arrow-forward 18dp} %s %s)",
                        audio_codec_overrides(audio_codec),
                        StringUtils.capitalize(audio_channel_layout.split("\\(")[0]),
                        audio_codec_overrides(stream_audio_codec),
                        StringUtils.capitalize(stream_audio_channel_layout.split("\\(")[0])
                );
            } else if (stream_audio_decision.equals("copy")) {
                return String.format("Direct Stream (%s %s)",
                        audio_codec_overrides(stream_audio_codec),
                        StringUtils.capitalize(stream_audio_channel_layout.split("\\(")[0])
                );
            } else {
                return String.format("Direct Stream (%s %s)",
                        audio_codec_overrides(audio_codec),
                        StringUtils.capitalize(audio_channel_layout.split("\\(")[0])
                );
            }
        }

        public String get_subtitle_codec_string() {
            if (Arrays.asList("movie", "episode", "clip").contains(media_type) && subtitles == 1) {
                if (stream_video_decision.equals("transcode")) {
                    return String.format("Transcode (%s {md-arrow-forward 18dp} %s)", subtitle_codec.toUpperCase(), stream_subtitle_codec.toUpperCase());
                } else if(stream_video_decision.equals("copy")){
                    return String.format("Direct Stream (%s)", subtitle_codec.toUpperCase());
                } else if(stream_video_decision.equals("burn")){
                    return String.format("Burn (%s)", subtitle_codec.toUpperCase());
                } else {
                    return String.format("Direct Play (%s)", synced_version == 1 ? stream_subtitle_codec.toUpperCase() : subtitle_codec.toUpperCase() );
                }
            }
            return String.format("None");
        }

        public String get_ip_address_string() {
            if(!ip_address.equals("N/A")){
                return String.format("%s: %s", location.toUpperCase(), ip_address);
            }
            return "N/A";
        }

        public String get_bandwidth_string() {
            Integer bw = Integer.valueOf(bandwidth);
            if(!media_type.equals("photo") && !bw.equals(0)) {
                if(bw > 1000) {
                    return String.format("%.1f %s", bw / 1000.0, "Mbps");
                } else {
                    return String.valueOf(bw) + " kbps";
                }
            }
            return "";
        }

        public String video_resolution_overrides(String resolution) {
            switch (resolution) {
                case "sd":
                    return "SD";
                case "480":
                    return "480p";
                case "540":
                    return "540p";
                case "576":
                    return "576p";
                case "720":
                    return "720p";
                case "1080":
                    return "1080p";
                case "4k":
                    return "4k";
                default:
                    return resolution;
            }
        }

        public String audio_codec_overrides(String codec){
            switch(codec){
                case "truehd":
                    return "TrueHD";
                default:
                    return codec.toUpperCase();
            }
        }
    }
}
