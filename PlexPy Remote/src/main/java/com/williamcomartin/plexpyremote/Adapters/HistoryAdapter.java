package com.williamcomartin.plexpyremote.Adapters;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.res.Resources;
import android.graphics.drawable.Icon;
import android.preference.PreferenceManager;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.CardView;
import android.support.v7.widget.RecyclerView;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.joanzapata.iconify.widget.IconTextView;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.ImageCacheManager;
import com.williamcomartin.plexpyremote.Models.ActivityModels;
import com.williamcomartin.plexpyremote.Models.HistoryModels;
import com.williamcomartin.plexpyremote.R;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

/**
 * Created by wcomartin on 2015-12-03.
 */
public class HistoryAdapter extends RecyclerView.Adapter<HistoryAdapter.ViewHolder> {


    private SharedPreferences SP;

    public static class ViewHolder extends RecyclerView.ViewHolder {

        private final CardView vCard;
        private final CardView vCardSecondary;

        private final TextView vTitle;
        private final TextView vDate;
        private final NetworkImageView vImage;
        private final TextView vUser;
        private final TextView vEpisode;

        private final IconTextView vState;
        private final IconTextView vProgress;
        private final TextView vProgressText;

        private final TextView vStarted;
        private final TextView vStopped;
        private final TextView vPaused;
        private final TextView vDuration;
        private final TextView vIPAddress;
        private final TextView vPlayer;

        public ViewHolder(View itemView) {
            super(itemView);

            vCard = (CardView) itemView.findViewById(R.id.history_card_view);
            vCardSecondary = (CardView) itemView.findViewById(R.id.history_card_secondary_view);

            vTitle = (TextView) itemView.findViewById(R.id.history_card_title);
            vDate = (TextView) itemView.findViewById(R.id.history_card_date);
            vImage = (NetworkImageView) itemView.findViewById(R.id.history_card_image);
            vUser = (TextView) itemView.findViewById(R.id.history_card_user);
            vEpisode = (TextView) itemView.findViewById(R.id.history_card_episode);

            vState = (IconTextView) itemView.findViewById(R.id.history_card_state);
            vProgress = (IconTextView) itemView.findViewById(R.id.history_card_progress);
            vProgressText = (TextView) itemView.findViewById(R.id.history_card_progress_text);

            vStarted = (TextView) itemView.findViewById(R.id.history_card_started);
            vStopped = (TextView) itemView.findViewById(R.id.history_card_stopped);
            vPaused = (TextView) itemView.findViewById(R.id.history_card_paused);
            vDuration = (TextView) itemView.findViewById(R.id.history_card_duration);
            vIPAddress = (TextView) itemView.findViewById(R.id.history_card_ipaddress);
            vPlayer = (TextView) itemView.findViewById(R.id.history_card_player);
        }
    }

    private Context context;
    private List<HistoryModels.HistoryRecord> historyItems;

    // Pass in the contact array into the constructor
    public HistoryAdapter(Context context, List<HistoryModels.HistoryRecord> historyItems) {
        this.context = context;
        this.historyItems = historyItems;
        SP = PreferenceManager.getDefaultSharedPreferences(ApplicationController.getInstance().getApplicationContext());
    }

    public void setHistory(List<HistoryModels.HistoryRecord> historyItems) {
        this.historyItems.clear();
        if (historyItems != null) {
            this.historyItems.addAll(historyItems);
        }
        notifyDataSetChanged();
    }

    @Override
    public HistoryAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        Context context = parent.getContext();
        LayoutInflater inflater = LayoutInflater.from(context);

        // Inflate the custom layout
        View contactView = inflater.inflate(R.layout.item_history, parent, false);

        // Return a new holder instance
        ViewHolder viewHolder = new ViewHolder(contactView);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(final HistoryAdapter.ViewHolder viewHolder, int position) {
        // Get the data model based on position
        final HistoryModels.HistoryRecord historyItem = historyItems.get(position);

        if(historyItem.detailsOpen == null) historyItem.detailsOpen = false;
        toggleDetailsView(viewHolder, historyItem.detailsOpen);
        viewHolder.vCard.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) viewHolder.vCardSecondary.getLayoutParams();
                if (params.topMargin == 0) historyItem.detailsOpen = true;
                else historyItem.detailsOpen = false;
                toggleDetailsView(viewHolder, historyItem.detailsOpen);
                return true;
            }
        });

        // Set item views based on the data model
        viewHolder.vTitle.setText(historyItem.fullTitle);
        viewHolder.vUser.setText(historyItem.friendlyName);
        viewHolder.vImage.setImageUrl(UrlHelpers.getImageUrl(historyItem.thumb, "600", "400"),
                ImageCacheManager.getInstance().getImageLoader());

        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");

        if (historyItem.date != null && !historyItem.date.equals("null")) {
            String date = format.format(historyItem.date * 1000);
            viewHolder.vDate.setText(date);
        }

        if(historyItem.mediaType != null) {
            switch (historyItem.mediaType){
                case "episode":
                    viewHolder.vEpisode.setText("S" + historyItem.parentMediaIndex + " • E" + historyItem.mediaIndex);
                    break;
                case "movie":
                    viewHolder.vEpisode.setText(String.valueOf(historyItem.year));
                    break;
            }
        }

        if (historyItem.state != null) {
            switch (historyItem.state) {
                case "playing":
                    viewHolder.vState.setText("{fa-play}");
                    viewHolder.vCard.setCardBackgroundColor(ContextCompat.getColor(this.context, R.color.colorCardLightBackground));
                    break;
                case "paused":
                    viewHolder.vState.setText("{fa-pause}");
                    viewHolder.vCard.setCardBackgroundColor(ContextCompat.getColor(this.context, R.color.colorCardLightBackground));
                    break;
                default:
                    viewHolder.vState.setText("");
                    viewHolder.vCard.setCardBackgroundColor(ContextCompat.getColor(this.context, R.color.colorCardBackground));
                    break;
            }
        } else {
            viewHolder.vState.setText("");
            viewHolder.vCard.setCardBackgroundColor(ContextCompat.getColor(this.context, R.color.colorCardBackground));
        }

        if (historyItem.percentComplete != null) {
            if (historyItem.percentComplete < 40) {
                viewHolder.vProgress.setText("{fa-circle-thin}");
            } else if (historyItem.percentComplete < 80) {
                viewHolder.vProgress.setText("{fa-adjust}");
            } else {
                viewHolder.vProgress.setText("{fa-circle}");
            }

            viewHolder.vProgressText.setText(String.valueOf(historyItem.percentComplete) + "%");
        }

        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
        if (historyItem.started != null) {
            String date = timeFormat.format(historyItem.started * 1000);
            viewHolder.vStarted.setText(date);
        }

        if (historyItem.stopped != null) {
            String date = timeFormat.format(historyItem.stopped * 1000);
            viewHolder.vStopped.setText(date);
        } else {
            viewHolder.vStopped.setText("N/A");
        }

        if (historyItem.pausedCounter != null) {
            viewHolder.vPaused.setText(formatMins(historyItem.pausedCounter * 1000));
        }

        if (historyItem.duration != null) {
            viewHolder.vDuration.setText(formatMins(historyItem.duration * 1000));
        }

        viewHolder.vIPAddress.setText(historyItem.ipAddress);
        viewHolder.vPlayer.setText(historyItem.player);
    }

    @Override
    public int getItemCount() {
        if (historyItems == null) return 0;
        return historyItems.size();
    }

    private int convertDpToPixel(float dp) {
        Resources resources = context.getResources();
        DisplayMetrics metrics = resources.getDisplayMetrics();
        return (int) (dp * ((float) metrics.densityDpi / DisplayMetrics.DENSITY_DEFAULT));
    }

    private String formatMins(Long millis) {
        return String.format(Locale.US, "%d mins",
                TimeUnit.MILLISECONDS.toMinutes(millis)
        );
    }

    private void toggleDetailsView(HistoryAdapter.ViewHolder viewHolder, Boolean detailsOpen){
        int topMargin;
        if(detailsOpen) {
            topMargin = convertDpToPixel(99);
            viewHolder.vProgressText.setVisibility(View.VISIBLE);
            viewHolder.vProgress.setVisibility(View.GONE);
        } else {
            topMargin = 0;
            viewHolder.vProgressText.setVisibility(View.GONE);
            viewHolder.vProgress.setVisibility(View.VISIBLE);
        }

        RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) viewHolder.vCardSecondary.getLayoutParams();
        params.setMargins(0, topMargin, 0, 0);
        viewHolder.vCardSecondary.setLayoutParams(params);
    }
}
