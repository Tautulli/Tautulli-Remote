package com.williamcomartin.plexpyremote.SharedFragments;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.williamcomartin.plexpyremote.Models.LibraryGlobalStatsModels;
import com.williamcomartin.plexpyremote.Models.UserPlayerStatsModels;
import com.williamcomartin.plexpyremote.R;

import java.util.List;

public class PlayerStatsFragment extends Fragment {

    private int mColumnCount = 2;
    private List<LibraryGlobalStatsModels.LibraryGlobalStat> userID;
    private List<UserPlayerStatsModels.PlayerStat> playerStats;

    private RecyclerView playerStatsRecyclerView;

    public PlayerStatsFragment() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_player_stats, container, false);
        playerStatsRecyclerView = view.findViewById(R.id.player_stats_list);

        // Set the adapter
        Context context = view.getContext();
        playerStatsRecyclerView.setLayoutManager(new LinearLayoutManager(context));
        return view;
    }

    public void setPlayerStats(List<UserPlayerStatsModels.PlayerStat> playerStats) {
        this.playerStats = playerStats;
        playerStatsRecyclerView.setAdapter(new PlayerStatsRecyclerViewAdapter(this.playerStats));
    }
}
