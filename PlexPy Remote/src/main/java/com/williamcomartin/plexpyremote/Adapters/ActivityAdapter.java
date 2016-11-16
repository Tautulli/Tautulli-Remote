package com.williamcomartin.plexpyremote.Adapters;

import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.PorterDuff;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.joanzapata.iconify.IconDrawable;
import com.joanzapata.iconify.fonts.FontAwesomeIcons;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Models.ActivityModels.Activity;
import com.williamcomartin.plexpyremote.R;

import org.w3c.dom.Text;

import java.util.List;

/**
 * Created by wcomartin on 2015-11-25.
 */
public class ActivityAdapter extends RecyclerView.Adapter<ActivityAdapter.ViewHolder> {

    View itemView;
    private SharedPreferences SP;

    public ActivityAdapter() {

    }

    public static class ViewHolder extends RecyclerView.ViewHolder {


        protected TextView vTitle;
        protected TextView vSubTitle;
        protected TextView vEpisode;

        protected TextView vMediaType;

        protected TextView vStateIcon;
        protected TextView vStateText;

        protected TextView vUserIcon;
        protected TextView vUserText;

        protected TextView vDecisionIcon;
        protected TextView vDecisionText;

        protected ProgressBar vprogress;

        protected NetworkImageView vImage;

        public ViewHolder(View itemView) {
            super(itemView);

            vTitle = (TextView) itemView.findViewById(R.id.activity_card_title);
            vSubTitle = (TextView) itemView.findViewById(R.id.activity_card_subtitle);
            vEpisode = (TextView) itemView.findViewById(R.id.activity_card_episode);

            vMediaType = (TextView) itemView.findViewById(R.id.activity_card_media_type);

            vStateIcon = (TextView) itemView.findViewById(R.id.activity_card_state_icon);
            vStateText = (TextView) itemView.findViewById(R.id.activity_card_state_text);

            vUserIcon = (TextView) itemView.findViewById(R.id.activity_card_user_icon);
            vUserText = (TextView) itemView.findViewById(R.id.activity_card_user_text);

            vDecisionIcon = (TextView) itemView.findViewById(R.id.activity_card_decision_icon);
            vDecisionText = (TextView) itemView.findViewById(R.id.activity_card_decision_text);

            vprogress = (ProgressBar) itemView.findViewById(R.id.progressbar);

            vImage = (NetworkImageView) itemView.findViewById(R.id.activity_card_image);

        }
    }

    private List<Activity> activities;

    // Pass in the contact array into the constructor
    public ActivityAdapter(List<Activity> activities) {
        this.activities = activities;
    }

    @Override
    public ActivityAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        Context context = parent.getContext();
        LayoutInflater inflater = LayoutInflater.from(context);

        // Inflate the custom layout
        itemView = inflater.inflate(R.layout.item_activity, parent, false);

        // Return a new holder instance
        ViewHolder viewHolder = new ViewHolder(itemView);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(final ActivityAdapter.ViewHolder viewHolder, int position) {
        Context context = ApplicationController.getInstance().getApplicationContext();
        // Get the data model based on position
        Activity activity = activities.get(position);

        // Set item views based on the data model
        if (activity.media_type.equals("episode")) {
            viewHolder.vTitle.setText(activity.grandparent_title);
            viewHolder.vSubTitle.setText(activity.title);
            viewHolder.vMediaType.setText("{fa-television}");
            viewHolder.vEpisode.setText("S" + String.format("%02d", Integer.parseInt(activity.parent_media_index))
                    + "E" + String.format("%02d", Integer.parseInt(activity.media_index)));
        } else {
            viewHolder.vTitle.setText(activity.title);
            if (activity.media_type.equals("track")){
                viewHolder.vSubTitle.setText(activity.grandparent_title + " - " + activity.parent_title);
                viewHolder.vMediaType.setText("{fa-headphones}");
            } else {
                viewHolder.vSubTitle.setText(activity.year);
                viewHolder.vMediaType.setText("{fa-film}");
            }
        }

        if(activity.state.equals("playing")) {
            viewHolder.vStateIcon.setText("{fa-play}");
            viewHolder.vStateText.setText("Playing");
        } else if(activity.state.equals("paused")) {
            viewHolder.vStateIcon.setText("{fa-pause}");
            viewHolder.vStateText.setText("Paused");
        } else if(activity.state.equals("buffering")){
            viewHolder.vStateIcon.setText("{fa-spinner}");
            viewHolder.vStateText.setText("Buffering");
        }

        viewHolder.vUserIcon.setText("{fa-user}");
        viewHolder.vUserText.setText(activity.friendly_name);

        viewHolder.vDecisionIcon.setText("{fa-server}");
        if (activity.video_decision.equals("direct play")) {
            viewHolder.vDecisionText.setText("Direct Play");
        } else if (activity.video_decision.equals("copy")) {
            viewHolder.vDecisionText.setText("Direct Stream");
        } else {
            viewHolder.vDecisionText.setText("Transcoding");
        }

        viewHolder.vprogress.setProgress(Integer.parseInt(activity.progress_percent));
        viewHolder.vprogress.setSecondaryProgress(Integer.parseInt(activity.transcode_progress));

        String imageUrl;
        if (!activity.grandparent_thumb.equals("")) {
            imageUrl = UrlHelpers.getImageUrl(activity.grandparent_thumb, "500", "280");
        } else if (!activity.parent_thumb.equals("")) {
            imageUrl = UrlHelpers.getImageUrl(activity.parent_thumb, "500", "280");
        } else {
            imageUrl = UrlHelpers.getImageUrl(activity.thumb, "500", "280");
        }
        viewHolder.vImage.setImageUrl(imageUrl, ApplicationController.getInstance().getImageLoader());


    }

    @Override
    public int getItemCount() {
        if (activities == null) {
            return 0;
        }
        return activities.size();
    }
}
