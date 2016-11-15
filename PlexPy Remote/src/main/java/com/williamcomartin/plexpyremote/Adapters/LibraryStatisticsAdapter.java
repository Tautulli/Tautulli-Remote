package com.williamcomartin.plexpyremote.Adapters;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Models.LibraryStatisticsModels;
import com.williamcomartin.plexpyremote.R;

import java.util.List;

/**
 * Created by wcomartin on 2015-12-03.
 */
public class LibraryStatisticsAdapter extends RecyclerView.Adapter<LibraryStatisticsAdapter.ViewHolder> {


    private SharedPreferences SP;

    public static class ViewHolder extends RecyclerView.ViewHolder {

        private final TextView vTitle;
        private final TextView vCount;
        private final TextView vChildCount;
        private final LinearLayout vEpisodeLayout;
        private final NetworkImageView vImage;

        public ViewHolder(View itemView) {
            super(itemView);

            vTitle = (TextView) itemView.findViewById(R.id.library_statistics_card_title);
            vCount = (TextView) itemView.findViewById(R.id.library_statistics_card_count);
            vChildCount = (TextView) itemView.findViewById(R.id.library_statistics_card_child_count);
            vImage = (NetworkImageView) itemView.findViewById(R.id.library_statistics_card_image);

            vEpisodeLayout = (LinearLayout) itemView.findViewById(R.id.library_statistics_card_child);

        }
    }

    private List<LibraryStatisticsModels.LibraryStat> libraryStatisticsItem;

    // Pass in the contact array into the constructor
    public LibraryStatisticsAdapter(List<LibraryStatisticsModels.LibraryStat> libraryStatisticsItem) {
        this.libraryStatisticsItem = libraryStatisticsItem;
        SP = PreferenceManager.getDefaultSharedPreferences(ApplicationController.getInstance().getApplicationContext());
    }

    @Override
    public LibraryStatisticsAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        Context context = parent.getContext();
        LayoutInflater inflater = LayoutInflater.from(context);

        // Inflate the custom layout
        View contactView = inflater.inflate(R.layout.item_library_statistics, parent, false);

        // Return a new holder instance
        ViewHolder viewHolder = new ViewHolder(contactView);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(LibraryStatisticsAdapter.ViewHolder viewHolder, int position) {
        // Get the data model based on position
        LibraryStatisticsModels.LibraryStat item = libraryStatisticsItem.get(position);

        // Set item views based on the data model
        viewHolder.vTitle.setText(item.sectionName);
        viewHolder.vCount.setText(item.count);
        viewHolder.vChildCount.setText(item.childCount);
        viewHolder.vImage.setImageUrl(UrlHelpers.getImageUrl(item.thumb, "400", "400", "cover"),
                ApplicationController.getInstance().getImageLoader());

        if(item.childCount == null){
            viewHolder.vEpisodeLayout.setVisibility(LinearLayout.GONE);
        }

    }

    @Override
    public int getItemCount() {
        return libraryStatisticsItem.size();
    }
}
