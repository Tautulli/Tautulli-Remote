package com.williamcomartin.plexpyremote;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v7.app.ActionBar;
import android.util.Log;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.Helpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Models.UserPlayerStatsModels;
import com.williamcomartin.plexpyremote.Models.UserWatchStatsModels;
import com.williamcomartin.plexpyremote.UserDetailsFragments.UserPlayerStatsFragment;
import com.williamcomartin.plexpyremote.UserDetailsFragments.UserWatchStatsFragment;

public class UserDetailActivity extends NavBaseActivity {

    private Intent intent;
    private SharedPreferences SP;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        SP = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());

        intent = getIntent();

        setContentView(R.layout.activity_user_detail);
        setupActionBar();

        setupWatchStats();
        setupPlayerStats();
    }

    private void setupWatchStats() {
        if (findViewById(R.id.watch_stats) != null) {

            String url = UrlHelpers.getHostPlusAPIKey()
                    + "&cmd=get_user_watch_time_stats&user_id=" + ((Integer) intent.getIntExtra("ID", 0)).toString();

            GsonRequest<UserWatchStatsModels> request = new GsonRequest<>(
                    url,
                    UserWatchStatsModels.class,
                    null,
                    new Response.Listener<UserWatchStatsModels>() {
                        @Override
                        public void onResponse(UserWatchStatsModels response) {
                            for (UserWatchStatsModels.WatchStat stat : response.response.data){
                                UserWatchStatsFragment fragment = new UserWatchStatsFragment();
                                fragment.setStat(stat);
                                getSupportFragmentManager().beginTransaction().add(R.id.watch_stats, fragment).commit();
                            }
                        }
                    },
                    new Response.ErrorListener() {
                        @Override
                        public void onErrorResponse(VolleyError error) {

                        }
                    }
            );

            ApplicationController.getInstance().addToRequestQueue(request);
        }
    }

    private void setupPlayerStats() {
        if (findViewById(R.id.player_stats) != null) {

            String url = UrlHelpers.getHostPlusAPIKey()
                    + "&cmd=get_user_player_stats&user_id=" + ((Integer) intent.getIntExtra("ID", 0)).toString();

            GsonRequest<UserPlayerStatsModels> request = new GsonRequest<>(
                    url,
                    UserPlayerStatsModels.class,
                    null,
                    new Response.Listener<UserPlayerStatsModels>() {
                        @Override
                        public void onResponse(UserPlayerStatsModels response) {
                            Log.d("UserPlayerStats", response.toString());
                            for (UserPlayerStatsModels.PlayerStat stat : response.response.data){
                                UserPlayerStatsFragment fragment = new UserPlayerStatsFragment();
                                fragment.setStat(stat);
                                getSupportFragmentManager().beginTransaction().add(R.id.player_stats, fragment).commit();
                            }
                        }
                    },
                    new Response.ErrorListener() {
                        @Override
                        public void onErrorResponse(VolleyError error) {

                        }
                    }
            );

            ApplicationController.getInstance().addToRequestQueue(request);
        }
    }

    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(intent.getStringExtra("NAME"));
    }
}
