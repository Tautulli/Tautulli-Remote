package com.williamcomartin.plexwatch;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexwatch.Adapters.ActivityAdapter;
import com.williamcomartin.plexwatch.Helpers.GsonRequest;
import com.williamcomartin.plexwatch.Models.ActivityModels;
import com.williamcomartin.plexwatch.Models.ActivityModels.Activity;

import java.util.ArrayList;
import java.util.Collections;

public class ActivityActivity extends NavBaseActivity {

    private RecyclerView rvActivities;

    private SharedPreferences SP;
    private SwipeRefreshLayout mSwipeRefreshLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_activity);
        setupActionBar();

        refreshItems();

        mSwipeRefreshLayout = (SwipeRefreshLayout) findViewById(R.id.swipeRefreshLayoutActivities);

        mSwipeRefreshLayout.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                // Refresh items
                refreshItems();
            }
        });
    }

    private void refreshItems() {
        SP = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());

        rvActivities = (RecyclerView) findViewById(R.id.rvActivities);

        String url = SP.getString("server_settings_address", "") + "/api/v2?apikey=" + SP.getString("server_settings_apikey", "") + "&cmd=get_activity";

        GsonRequest<ActivityModels> request = new GsonRequest<>(
                url,
                ActivityModels.class,
                null,
                requestListener(),
                errorListener()
        );

        ApplicationController.getInstance().addToRequestQueue(request);

        rvActivities.setLayoutManager(new LinearLayoutManager(this));
    }

    private void onItemsLoadComplete() {
        if(mSwipeRefreshLayout != null) {
            mSwipeRefreshLayout.setRefreshing(false);
        }
    }

    private Response.ErrorListener errorListener() {
        onItemsLoadComplete();
        return new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
            }
        };
    }

    private Response.Listener<ActivityModels> requestListener() {
        return new Response.Listener<ActivityModels>() {
            @Override
            public void onResponse(ActivityModels response) {
                ActivityAdapter adapter = new ActivityAdapter(response.response.data.sessions);

                rvActivities.setAdapter(adapter);
                onItemsLoadComplete();
            }
        };
    }



    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.activity);
    }

}
