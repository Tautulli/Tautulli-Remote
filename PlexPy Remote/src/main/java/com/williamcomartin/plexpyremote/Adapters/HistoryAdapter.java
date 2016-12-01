package com.williamcomartin.plexpyremote.Adapters;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Models.HistoryModels;
import com.williamcomartin.plexpyremote.R;

import java.text.SimpleDateFormat;
import java.util.List;

/**
 * Created by wcomartin on 2015-12-03.
 */
public class HistoryAdapter extends RecyclerView.Adapter<HistoryAdapter.ViewHolder> {


    private SharedPreferences SP;

    public static class ViewHolder extends RecyclerView.ViewHolder {

        private final TextView vTitle;
        private final TextView vDate;
        private final NetworkImageView vImage;
        private final TextView vUser;

        public ViewHolder(View itemView) {
            super(itemView);

            vTitle = (TextView) itemView.findViewById(R.id.history_card_title);
            vDate = (TextView) itemView.findViewById(R.id.history_card_date);
            vImage = (NetworkImageView) itemView.findViewById(R.id.history_card_image);
            vUser = (TextView) itemView.findViewById(R.id.history_card_user);

        }
    }

    private List<HistoryModels.HistoryRecord> historyItems;

    // Pass in the contact array into the constructor
    public HistoryAdapter(List<HistoryModels.HistoryRecord> historyItems) {
        this.historyItems = historyItems;
        SP = PreferenceManager.getDefaultSharedPreferences(ApplicationController.getInstance().getApplicationContext());
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
    public void onBindViewHolder(HistoryAdapter.ViewHolder viewHolder, int position) {
        // Get the data model based on position
        HistoryModels.HistoryRecord historyItem = historyItems.get(position);

        // Set item views based on the data model
        viewHolder.vTitle.setText(historyItem.fullTitle);
        viewHolder.vUser.setText(historyItem.friendlyName);
        viewHolder.vImage.setImageUrl(UrlHelpers.getImageUrl(historyItem.thumb, "600", "400"),
                ApplicationController.getInstance().getImageLoader());

        if(historyItem.date != null && !historyItem.date.equals("null")){
            SimpleDateFormat format = new SimpleDateFormat("MMM dd,yyyy  hh:mm a");
//            String date = DateUtils.formatDateTime(ApplicationController.getInstance().getBaseContext(), historyItem.date, 0);
            String date = format.format(historyItem.date * 1000);
            Log.d("DATETIME", date);
            viewHolder.vDate.setText(date);
        }


    }

    @Override
    public int getItemCount() {
        if(historyItems == null) return 0;
        return historyItems.size();
    }
}
