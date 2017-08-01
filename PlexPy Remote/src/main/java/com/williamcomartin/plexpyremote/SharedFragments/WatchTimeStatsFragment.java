package com.williamcomartin.plexpyremote.SharedFragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.williamcomartin.plexpyremote.Helpers.TimeHelpers;
import com.williamcomartin.plexpyremote.Models.LibraryGlobalStatsModels;
import com.williamcomartin.plexpyremote.R;

import java.util.List;

public class WatchTimeStatsFragment extends Fragment {

    private TextView last24Plays;
    private RelativeLayout last24DaysLayout;
    private TextView last24Days;
    private RelativeLayout last24HrsLayout;
    private TextView last24Hrs;
    private RelativeLayout last24MinsLayout;
    private TextView last24Mins;

    private TextView last7Plays;
    private RelativeLayout last7DaysLayout;
    private TextView last7Days;
    private RelativeLayout last7HrsLayout;
    private TextView last7Hrs;
    private RelativeLayout last7MinsLayout;
    private TextView last7Mins;

    private TextView last30Plays;
    private RelativeLayout last30DaysLayout;
    private TextView last30Days;
    private RelativeLayout last30HrsLayout;
    private TextView last30Hrs;
    private RelativeLayout last30MinsLayout;
    private TextView last30Mins;

    private TextView lastAllPlays;
    private RelativeLayout lastAllDaysLayout;
    private TextView lastAllDays;
    private RelativeLayout lastAllHrsLayout;
    private TextView lastAllHrs;
    private RelativeLayout lastAllMinsLayout;
    private TextView lastAllMins;

    public WatchTimeStatsFragment() {}

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_watch_time_stats, container, false);

        last24Plays = (TextView) view.findViewById(R.id.library_details_global_24_plays);

        last24DaysLayout = (RelativeLayout) view.findViewById(R.id.library_details_global_24_days_layout);
        last24Days = (TextView) view.findViewById(R.id.library_details_global_24_days);

        last24HrsLayout = (RelativeLayout) view.findViewById(R.id.library_details_global_24_hrs_layout);
        last24Hrs = (TextView) view.findViewById(R.id.library_details_global_24_hrs);

        last24MinsLayout = (RelativeLayout) view.findViewById(R.id.library_details_global_24_mins_layout);
        last24Mins = (TextView) view.findViewById(R.id.library_details_global_24_mins);

        last7Plays = (TextView) view.findViewById(R.id.library_details_global_7_plays);

        last7DaysLayout = (RelativeLayout) view.findViewById(R.id.library_details_global_7_days_layout);
        last7Days = (TextView) view.findViewById(R.id.library_details_global_7_days);

        last7HrsLayout = (RelativeLayout) view.findViewById(R.id.library_details_global_7_hrs_layout);
        last7Hrs = (TextView) view.findViewById(R.id.library_details_global_7_hrs);

        last7MinsLayout = (RelativeLayout) view.findViewById(R.id.library_details_global_7_mins_layout);
        last7Mins = (TextView) view.findViewById(R.id.library_details_global_7_mins);

        last30Plays = (TextView) view.findViewById(R.id.library_details_global_30_plays);

        last30DaysLayout = (RelativeLayout) view.findViewById(R.id.library_details_global_30_days_layout);
        last30Days = (TextView) view.findViewById(R.id.library_details_global_30_days);

        last30HrsLayout = (RelativeLayout) view.findViewById(R.id.library_details_global_30_hrs_layout);
        last30Hrs = (TextView) view.findViewById(R.id.library_details_global_30_hrs);

        last30MinsLayout = (RelativeLayout) view.findViewById(R.id.library_details_global_30_mins_layout);
        last30Mins = (TextView) view.findViewById(R.id.library_details_global_30_mins);

        lastAllPlays = (TextView) view.findViewById(R.id.library_details_global_all_plays);

        lastAllDaysLayout = (RelativeLayout) view.findViewById(R.id.library_details_global_all_days_layout);
        lastAllDays = (TextView) view.findViewById(R.id.library_details_global_all_days);

        lastAllHrsLayout = (RelativeLayout) view.findViewById(R.id.library_details_global_all_hrs_layout);
        lastAllHrs = (TextView) view.findViewById(R.id.library_details_global_all_hrs);

        lastAllMinsLayout = (RelativeLayout) view.findViewById(R.id.library_details_global_all_mins_layout);
        lastAllMins = (TextView) view.findViewById(R.id.library_details_global_all_mins);

        return view;
    }

    public void setGlobalStats(List<LibraryGlobalStatsModels.LibraryGlobalStat> data){

        for (LibraryGlobalStatsModels.LibraryGlobalStat stat: data) {

            TimeHelpers.SplitDuration duration = TimeHelpers.splitTimestamp(stat.totalTime);

            if(stat.queryDays == 1){
                last24Plays.setText(String.valueOf(stat.totalPlays));
                if(duration.days == 0){
                    last24DaysLayout.setVisibility(View.GONE);
                } else {
                    last24Days.setText(String.valueOf(duration.days));
                }

                if(duration.days == 0 && duration.hours == 0){
                    last24HrsLayout.setVisibility(View.GONE);
                } else {
                    last24Hrs.setText(String.valueOf(duration.hours));
                }

                if(duration.days == 0 && duration.hours == 0 && duration.minutes == 0){
                    last24MinsLayout.setVisibility(View.GONE);
                } else {
                    last24Mins.setText(String.valueOf(duration.minutes));
                }
            } else if(stat.queryDays == 7){
                last7Plays.setText(String.valueOf(stat.totalPlays));
                if(duration.days == 0){
                    last7DaysLayout.setVisibility(View.GONE);
                } else {
                    last7Days.setText(String.valueOf(duration.days));
                }

                if(duration.days == 0 && duration.hours == 0){
                    last7HrsLayout.setVisibility(View.GONE);
                } else {
                    last7Hrs.setText(String.valueOf(duration.hours));
                }

                if(duration.days == 0 && duration.hours == 0 && duration.minutes == 0){
                    last7MinsLayout.setVisibility(View.GONE);
                } else {
                    last7Mins.setText(String.valueOf(duration.minutes));
                }
            } else if(stat.queryDays == 30){
                last30Plays.setText(String.valueOf(stat.totalPlays));
                if(duration.days == 0){
                    last30DaysLayout.setVisibility(View.GONE);
                } else {
                    last30Days.setText(String.valueOf(duration.days));
                }

                if(duration.days == 0 && duration.hours == 0){
                    last30HrsLayout.setVisibility(View.GONE);
                } else {
                    last30Hrs.setText(String.valueOf(duration.hours));
                }

                if(duration.days == 0 && duration.hours == 0 && duration.minutes == 0){
                    last30MinsLayout.setVisibility(View.GONE);
                } else {
                    last30Mins.setText(String.valueOf(duration.minutes));
                }
            } else if(stat.queryDays == 0){
                lastAllPlays.setText(String.valueOf(stat.totalPlays));
                if(duration.days == 0){
                    lastAllDaysLayout.setVisibility(View.GONE);
                } else {
                    lastAllDays.setText(String.valueOf(duration.days));
                }

                if(duration.days == 0 && duration.hours == 0){
                    lastAllHrsLayout.setVisibility(View.GONE);
                } else {
                    lastAllHrs.setText(String.valueOf(duration.hours));
                }

                if(duration.days == 0 && duration.hours == 0 && duration.minutes == 0){
                    lastAllMinsLayout.setVisibility(View.GONE);
                } else {
                    lastAllMins.setText(String.valueOf(duration.minutes));
                }
            }
        }

    }



}
