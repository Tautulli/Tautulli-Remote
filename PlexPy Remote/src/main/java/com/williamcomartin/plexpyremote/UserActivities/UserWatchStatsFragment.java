package com.williamcomartin.plexpyremote.UserActivities;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.williamcomartin.plexpyremote.Models.UserWatchStatsModels;
import com.williamcomartin.plexpyremote.R;

import java.util.concurrent.TimeUnit;

public class UserWatchStatsFragment extends Fragment {

    private SharedPreferences SP;

    private UserWatchStatsModels.WatchStat mStat;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_watch_stats, container, false);

        TextView mTitle = (TextView) view.findViewById(R.id.watch_stats_card_title);
        switch (mStat.queryDays){
            case 1:
                mTitle.setText("Last 24 Hours");
                break;
            case 7:
            case 30:
                mTitle.setText("Last " + mStat.queryDays.toString() + " Days");
                break;
            case 0:
                mTitle.setText("All Time");
        }

        TextView mPlays = (TextView) view.findViewById(R.id.watch_stats_card_plays);
        mPlays.setText(mStat.totalPlays.toString());

        long day = TimeUnit.SECONDS.toDays(mStat.totalTime);
        long hours = TimeUnit.SECONDS.toHours(mStat.totalTime) - (day *24);
        long minute = TimeUnit.SECONDS.toMinutes(mStat.totalTime) - (TimeUnit.SECONDS.toHours(mStat.totalTime)* 60);

        TextView mDays = (TextView) view.findViewById(R.id.watch_stats_card_days);
        mDays.setText(((Long) day).toString());

        TextView mHours = (TextView) view.findViewById(R.id.watch_stats_card_hrs);
        mHours.setText(((Long) hours).toString());

        TextView mMinutes = (TextView) view.findViewById(R.id.watch_stats_card_mins);
        mMinutes.setText(((Long) minute).toString());

        return view;
    }

    public void setStat(UserWatchStatsModels.WatchStat stat) {
        mStat = stat;
    }
}
