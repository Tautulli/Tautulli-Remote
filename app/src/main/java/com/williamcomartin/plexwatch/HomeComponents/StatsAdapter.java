package com.williamcomartin.plexwatch.HomeComponents;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.williamcomartin.plexwatch.Models.Stat;
import com.williamcomartin.plexwatch.R;

import java.util.List;

/**
 * Created by wcomartin on 2015-11-04.
 */
public class StatsAdapter extends RecyclerView.Adapter<StatsAdapter.ViewHolder> {

    public static class ViewHolder extends RecyclerView.ViewHolder {
        public TextView nameTextView;
        public TextView valueTextView;

        public ViewHolder(View itemView) {
            super(itemView);

            nameTextView = (TextView) itemView.findViewById(R.id.stat_name);
            valueTextView = (TextView) itemView.findViewById(R.id.stat_value);

        }
    }

    private List<Stat> stats;

    // Pass in the contact array into the constructor
    public StatsAdapter(List<Stat> stats) {
        this.stats = stats;
    }

    @Override
    public StatsAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        Context context = parent.getContext();
        LayoutInflater inflater = LayoutInflater.from(context);

        // Inflate the custom layout
        View contactView = inflater.inflate(R.layout.item_stats, parent, false);

        // Return a new holder instance
        ViewHolder viewHolder = new ViewHolder(contactView);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(StatsAdapter.ViewHolder viewHolder, int position) {
        // Get the data model based on position
        Stat stat = stats.get(position);

        // Set item views based on the data model
        TextView nameView = viewHolder.nameTextView;
        nameView.setText(stat.getName());

        TextView valueView = viewHolder.valueTextView;
        valueView.setText(Integer.toString(stat.getValue()));
    }

    @Override
    public int getItemCount() {
        return stats.size();
    }

}
