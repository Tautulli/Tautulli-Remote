package com.williamcomartin.plexpyremote.UserDetailsFragments;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.williamcomartin.plexpyremote.Models.UserPlayerStatsModels;
import com.williamcomartin.plexpyremote.R;

public class UserPlayerStatsFragment extends Fragment {

    private SharedPreferences SP;

    private UserPlayerStatsModels.PlayerStat mStat;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_player_stats, container, false);



        return view;
    }

    public void setStat(UserPlayerStatsModels.PlayerStat stat) {
        mStat = stat;
    }
}
