package com.williamcomartin.plexwatch.Adapters.WatchStatistics;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.williamcomartin.plexwatch.ApplicationController;
import com.williamcomartin.plexwatch.Models.StatisticsModels;
import com.williamcomartin.plexwatch.R;

import java.text.SimpleDateFormat;
import java.util.List;

/**
 * Created by wcomartin on 16-05-20.
 */
public class LastWatchedAdapter extends RecyclerView.Adapter<LastWatchedAdapter.ViewHolder> {

    private final SharedPreferences SP;

    public static class ViewHolder extends RecyclerView.ViewHolder {

        private final NetworkImageView vImage;
        private final TextView vBadge;
        private final TextView vTitle;
        private final TextView vUser;
        private final TextView vDate;

        public ViewHolder(View itemView) {
            super(itemView);

            vImage = (NetworkImageView) itemView.findViewById(R.id.last_watched_card_image);
            vBadge = (TextView) itemView.findViewById(R.id.last_watched_card_badge);
            vTitle = (TextView) itemView.findViewById(R.id.last_watched_card_title);
            vUser = (TextView) itemView.findViewById(R.id.last_watched_card_user);
            vDate = (TextView) itemView.findViewById(R.id.last_watched_card_date);
        }
    }

    private List<StatisticsModels.StatisticsRow> statisticsItems;

    // Pass in the contact array into the constructor
    public LastWatchedAdapter(List<StatisticsModels.StatisticsRow> statisticsItems) {
        this.statisticsItems = statisticsItems;
        SP = PreferenceManager.getDefaultSharedPreferences(ApplicationController.getInstance().getApplicationContext());
    }

    @Override
    public LastWatchedAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        Context context = parent.getContext();
        LayoutInflater inflater = LayoutInflater.from(context);
        View contactView = inflater.inflate(R.layout.item_last_watched, parent, false);

        // Return a new holder instance
        return new ViewHolder(contactView);
    }

    @Override
    public void onBindViewHolder(LastWatchedAdapter.ViewHolder viewHolder, int position) {
        // Get the data model based on position
        StatisticsModels.StatisticsRow item = statisticsItems.get(position);

        if(item.media_type.equals("episode")){
            viewHolder.vImage.setImageUrl(SP.getString("server_settings_address", "") +
                    "/pms_image_proxy?width=400&height=600&img=" + item.grandparent_thumb,
                    ApplicationController.getInstance().getImageLoader());
        } else {
            viewHolder.vImage.setImageUrl(SP.getString("server_settings_address", "") +
                    "/pms_image_proxy?width=400&height=600&img=" + item.thumb,
                    ApplicationController.getInstance().getImageLoader());
        }

        viewHolder.vBadge.setText(((Integer) (position + 1)).toString());
        viewHolder.vTitle.setText(item.title);
        viewHolder.vUser.setText(item.friendly_name);

        Long dateTimeStamp = item.last_watch * 1000;
        SimpleDateFormat format = new SimpleDateFormat("MMM dd,yyyy");
        String date = format.format(dateTimeStamp);
        viewHolder.vDate.setText(date + " - " + item.player);

    }

    @Override
    public int getItemCount() {
        return statisticsItems.size();
    }
}
