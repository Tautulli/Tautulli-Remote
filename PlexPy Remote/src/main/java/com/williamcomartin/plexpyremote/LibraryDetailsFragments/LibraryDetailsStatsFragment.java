package com.williamcomartin.plexpyremote.LibraryDetailsFragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import com.android.volley.Response;
import com.android.volley.RetryPolicy;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;
import com.williamcomartin.plexpyremote.Models.LibraryGlobalStatsModels;
import com.williamcomartin.plexpyremote.Models.LibraryUsersStatsModels;
import com.williamcomartin.plexpyremote.R;

import java.net.MalformedURLException;

public class LibraryDetailsStatsFragment extends Fragment {
    private String libraryId;

    private boolean globalVisible = false;
    private boolean userVisible = false;

    private View view;

    public LibraryDetailsStatsFragment() {}

    public void setLibraryId(String libraryId){
        this.libraryId = libraryId;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.fragment_library_details_profile, container, false);
        setupStats((LinearLayout) view.findViewById(R.id.library_details_stats_layout), libraryId);
        return view;
    }

    private void setupStats(LinearLayout statsLayout, String libraryId){
        statsLayout.setVisibility(View.GONE);
        statsLayout.removeAllViewsInLayout();

        setupLibraryGlobalStats(statsLayout, libraryId);
        setupLibraryUserStats(statsLayout, libraryId);
    }

    private void setupLibraryGlobalStats(final LinearLayout statsLayout, final String libraryId){
        final LibraryDetailsGlobalFragment frag = new LibraryDetailsGlobalFragment();
        getFragmentManager().beginTransaction().add(statsLayout.getId(), frag).commit();
        try {
            GsonRequest<LibraryGlobalStatsModels> request = new GsonRequest<>(
                    UrlHelpers.getHostPlusAPIKey() + "&cmd=get_library_watch_time_stats&section_id=" + libraryId,
                    LibraryGlobalStatsModels.class,
                    null,
                    new Response.Listener<LibraryGlobalStatsModels>() {
                        @Override
                        public void onResponse(LibraryGlobalStatsModels response) {
                            frag.setGlobalStats(response.response.data);
                            globalVisible = true;
                            checkVisibility(statsLayout);
                        }
                    },
                    new Response.ErrorListener() {
                        @Override
                        public void onErrorResponse(VolleyError error) {
//                            setupStats(statsLayout, libraryId);
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

    private void setupLibraryUserStats(final LinearLayout statsLayout, final String libraryId){
        final LibraryDetailsUsersFragment frag = new LibraryDetailsUsersFragment();
        getFragmentManager().beginTransaction().add(statsLayout.getId(), frag).commit();
        try {
            GsonRequest<LibraryUsersStatsModels> request = new GsonRequest<>(
                    UrlHelpers.getHostPlusAPIKey() + "&cmd=get_library_user_stats&section_id=" + libraryId,
                    LibraryUsersStatsModels.class,
                    null,
                    new Response.Listener<LibraryUsersStatsModels>() {
                        @Override
                        public void onResponse(LibraryUsersStatsModels response) {
                            frag.setUsersStats(response.response.data);
                            userVisible = true;
                            checkVisibility(statsLayout);
                        }
                    },
                    new Response.ErrorListener() {
                        @Override
                        public void onErrorResponse(VolleyError error) {
                            Log.d("LibraryStats", error.getMessage());
                            if(error.getMessage().contains("com.google.gson.JsonSyntaxException")){
                                userVisible = true;
                                checkVisibility(statsLayout);
                            }
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

    private void checkVisibility(LinearLayout statsLayout){
        if(globalVisible && userVisible){
            view.findViewById(R.id.progressbar).setVisibility(View.GONE);
            statsLayout.setVisibility(View.VISIBLE);
        }
    }
}
