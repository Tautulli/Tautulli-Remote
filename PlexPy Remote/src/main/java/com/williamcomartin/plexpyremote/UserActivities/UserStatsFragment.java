package com.williamcomartin.plexpyremote.UserActivities;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import com.android.volley.Response;
import com.android.volley.RetryPolicy;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;
import com.williamcomartin.plexpyremote.Models.LibraryGlobalStatsModels;
import com.williamcomartin.plexpyremote.Models.UserPlayerStatsModels;
import com.williamcomartin.plexpyremote.R;
import com.williamcomartin.plexpyremote.SharedFragments.PlayerStatsFragment;
import com.williamcomartin.plexpyremote.SharedFragments.WatchTimeStatsFragment;

import java.net.MalformedURLException;

public class UserStatsFragment extends Fragment {

    private LinearLayout linearLayout;
    private String userID;

    public UserStatsFragment() {}

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_user_stats, container, false);
        linearLayout = (LinearLayout) view.findViewById(R.id.user_stats_watch_time_stats);
        setupWatchTimeStats();
        setupPlayerStats();
        return view;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public void setupWatchTimeStats() {
        final WatchTimeStatsFragment frag = new WatchTimeStatsFragment();
        getFragmentManager().beginTransaction().add(linearLayout.getId(), frag).commit();
        try {
            GsonRequest<LibraryGlobalStatsModels> request = new GsonRequest<>(
                    UrlHelpers.getHostPlusAPIKey() + "&cmd=get_user_watch_time_stats&user_id=" + userID,
                    LibraryGlobalStatsModels.class,
                    null,
                    new Response.Listener<LibraryGlobalStatsModels>() {
                        @Override
                        public void onResponse(LibraryGlobalStatsModels response) {
                            frag.setGlobalStats(response.response.data);
                        }
                    },
                    new Response.ErrorListener() {
                        @Override
                        public void onErrorResponse(VolleyError error) {
                        }
                    }
            );

            request.setRetryPolicy(new RetryPolicy() {
                @Override
                public int getCurrentTimeout() {
                    return 50000;
                }

                @Override
                public int getCurrentRetryCount() {
                    return 50000;
                }

                @Override
                public void retry(VolleyError error) throws VolleyError {

                }
            });

            RequestManager.addToRequestQueue(request);
        } catch (NoServerException | MalformedURLException e) {
            e.printStackTrace();
        }
    }

    public void setupPlayerStats() {
        final PlayerStatsFragment frag = new PlayerStatsFragment();
        getFragmentManager().beginTransaction().add(linearLayout.getId(), frag).commit();
        try {
            GsonRequest<UserPlayerStatsModels> request = new GsonRequest<>(
                    UrlHelpers.getHostPlusAPIKey() + "&cmd=get_user_player_stats&user_id=" + userID,
                    UserPlayerStatsModels.class,
                    null,
                    new Response.Listener<UserPlayerStatsModels>() {
                        @Override
                        public void onResponse(UserPlayerStatsModels response) {
                            frag.setPlayerStats(response.response.data);
                        }
                    },
                    new Response.ErrorListener() {
                        @Override
                        public void onErrorResponse(VolleyError error) {
                        }
                    }
            );

            request.setRetryPolicy(new RetryPolicy() {
                @Override
                public int getCurrentTimeout() {
                    return 50000;
                }

                @Override
                public int getCurrentRetryCount() {
                    return 50000;
                }

                @Override
                public void retry(VolleyError error) throws VolleyError {

                }
            });

            RequestManager.addToRequestQueue(request);
        } catch (NoServerException | MalformedURLException e) {
            e.printStackTrace();
        }
    }
}
