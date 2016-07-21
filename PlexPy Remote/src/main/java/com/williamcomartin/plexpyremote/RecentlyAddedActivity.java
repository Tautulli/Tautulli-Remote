package com.williamcomartin.plexpyremote;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.Adapters.RecentlyAddedAdapter;
import com.williamcomartin.plexpyremote.Helpers.EndlessScrollListener;
import com.williamcomartin.plexpyremote.Helpers.GsonRequest;
import com.williamcomartin.plexpyremote.Models.RecentlyAddedModels;

import java.util.ArrayList;

public class RecentlyAddedActivity extends NavBaseActivity {

    private RecyclerView rvActivities;

    private SharedPreferences SP;

    private RecentlyAddedAdapter adapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_recently_added);
        setupActionBar();

        SP = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());

        rvActivities = (RecyclerView) findViewById(R.id.rvRecentlyAdded);
        adapter = new RecentlyAddedAdapter(new ArrayList<RecentlyAddedModels.RecentItem>());
        rvActivities.setAdapter(adapter);

        String url = SP.getString("server_settings_address", "") + "/api/v2?apikey=" + SP.getString("server_settings_apikey", "") + "&cmd=get_recently_added&count=10";

        GsonRequest<RecentlyAddedModels> request = new GsonRequest<>(
                url,
                RecentlyAddedModels.class,
                null,
                requestListener(),
                errorListener()
        );

        ApplicationController.getInstance().addToRequestQueue(request);

        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this);
        rvActivities.setLayoutManager(linearLayoutManager);

        rvActivities.setOnScrollListener(new EndlessScrollListener(linearLayoutManager) {
            @Override
            public void onLoadMore(int current_page) {
                String url = SP.getString("server_settings_address", "") + "/api/v2?apikey=" + SP.getString("server_settings_apikey", "") + "&cmd=get_recently_added&count=10&start=" + ((Integer) current_page).toString();

                GsonRequest<RecentlyAddedModels> request = new GsonRequest<>(
                        url,
                        RecentlyAddedModels.class,
                        null,
                        requestListener(),
                        errorListener()
                );

                ApplicationController.getInstance().addToRequestQueue(request);
            }
        });

    }

    private Response.ErrorListener errorListener() {
        return new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
            }
        };
    }

    private Response.Listener<RecentlyAddedModels> requestListener() {
        return new Response.Listener<RecentlyAddedModels>() {
            @Override
            public void onResponse(RecentlyAddedModels response) {
                adapter.addItems(response.response.data.recentlyAdded);
                adapter.notifyDataSetChanged();
//                rvActivities.setAdapter(adapter);
            }
        };
    }

    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.recently_added);
    }
}
