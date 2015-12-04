package com.williamcomartin.plexwatch.Adapters;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.support.v7.widget.RecyclerView;
import android.text.format.DateUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.williamcomartin.plexwatch.ApplicationController;
import com.williamcomartin.plexwatch.Models.HistoryModels;
import com.williamcomartin.plexwatch.Models.UserModels;
import com.williamcomartin.plexwatch.R;

import java.util.List;

/**
 * Created by wcomartin on 2015-12-03.
 */
public class HistoryAdapter extends RecyclerView.Adapter<HistoryAdapter.ViewHolder> {


    private SharedPreferences SP;

    public static class ViewHolder extends RecyclerView.ViewHolder {

        public ViewHolder(View itemView) {
            super(itemView);

        }
    }

    private List<HistoryModels.History> historyItems;

    // Pass in the contact array into the constructor
    public HistoryAdapter(List<HistoryModels.History> historyItems) {
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
        HistoryModels.History historyItem = historyItems.get(position);

        // Set item views based on the data model


    }

    @Override
    public int getItemCount() {
        return historyItems.size();
    }
}
