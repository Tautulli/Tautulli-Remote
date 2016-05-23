package com.williamcomartin.plexwatch;

import android.app.Activity;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexwatch.Adapters.RecentlyAddedAdapter;
import com.williamcomartin.plexwatch.Helpers.GsonRequest;
import com.williamcomartin.plexwatch.Models.RecentlyAddedModels;

public class RecentlyAddedActivity extends NavBaseActivity {

    private RecyclerView rvActivities;

    private SharedPreferences SP;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_recently_added);
        setupActionBar();

        SP = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());

        rvActivities = (RecyclerView) findViewById(R.id.rvRecentlyAdded);

        String url = SP.getString("server_settings_address", "") + "/api/v2?apikey=" + SP.getString("server_settings_apikey", "") + "&cmd=get_recently_added&count=30";

        GsonRequest<RecentlyAddedModels> request = new GsonRequest<>(
                url,
                RecentlyAddedModels.class,
                null,
                requestListener(),
                errorListener()
        );

        ApplicationController.getInstance().addToRequestQueue(request);

        rvActivities.setLayoutManager(new LinearLayoutManager(this));
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
                RecentlyAddedAdapter adapter = new RecentlyAddedAdapter(response.response.data.recentlyAdded);
                rvActivities.setAdapter(adapter);
            }
        };
    }

    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.recently_added);
    }
}
