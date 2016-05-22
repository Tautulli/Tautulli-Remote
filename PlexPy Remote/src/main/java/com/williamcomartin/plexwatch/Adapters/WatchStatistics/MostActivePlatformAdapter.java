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
import com.williamcomartin.plexwatch.Services.PlatformService;

import java.util.List;

/**
 * Created by wcomartin on 16-05-20.
 */
public class MostActivePlatformAdapter extends RecyclerView.Adapter<MostActivePlatformAdapter.ViewHolder> {

    private final SharedPreferences SP;

    public static class ViewHolder extends RecyclerView.ViewHolder {

        private final NetworkImageView vImage;
        private final TextView vBadge;
        private final TextView vTitle;
        private final TextView vQuantity;
        private final TextView vQuantifier;

        public ViewHolder(View itemView) {
            super(itemView);

            vImage = (NetworkImageView) itemView.findViewById(R.id.standard_statistics_card_image);
            vBadge = (TextView) itemView.findViewById(R.id.standard_statistics_card_badge);
            vTitle = (TextView) itemView.findViewById(R.id.standard_statistics_card_title);
            vQuantity = (TextView) itemView.findViewById(R.id.standard_statistics_card_quantity);
            vQuantifier = (TextView) itemView.findViewById(R.id.standard_statistics_card_quantifier);
        }
    }

    private List<StatisticsModels.StatisticsRow> statisticsItems;

    // Pass in the contact array into the constructor
    public MostActivePlatformAdapter(List<StatisticsModels.StatisticsRow> statisticsItems) {
        this.statisticsItems = statisticsItems;
        SP = PreferenceManager.getDefaultSharedPreferences(ApplicationController.getInstance().getApplicationContext());
    }

    @Override
    public MostActivePlatformAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        Context context = parent.getContext();
        LayoutInflater inflater = LayoutInflater.from(context);
        View contactView = inflater.inflate(R.layout.item_standard_statistics, parent, false);

        // Return a new holder instance
        return new ViewHolder(contactView);
    }

    @Override
    public void onBindViewHolder(MostActivePlatformAdapter.ViewHolder viewHolder, int position) {
        // Get the data model based on position
        StatisticsModels.StatisticsRow item = statisticsItems.get(position);

        viewHolder.vImage.setImageUrl(SP.getString("server_settings_address", "") +
                PlatformService.getInstance().getPlatformImagePath(item.platform),
                ApplicationController.getInstance().getImageLoader());

        viewHolder.vBadge.setText(((Integer) (position + 1)).toString());
        viewHolder.vTitle.setText(item.platform);
        viewHolder.vQuantity.setText(item.total_plays.toString());

        viewHolder.vQuantifier.setText("plays");
    }

    @Override
    public int getItemCount() {
        return statisticsItems.size();
    }
}
