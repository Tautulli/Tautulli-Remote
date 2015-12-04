package com.williamcomartin.plexwatch;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.williamcomartin.plexwatch.Adapters.ActivityAdapter;
import com.williamcomartin.plexwatch.Helpers.GsonRequest;
import com.williamcomartin.plexwatch.Models.ActivityModels;
import com.williamcomartin.plexwatch.Models.ActivityModels.Activity;

import java.util.ArrayList;
import java.util.Collections;

public class ActivityActivity extends NavBaseActivity {

    private RecyclerView rvActivities;

    private SharedPreferences SP;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_activity);
        setupActionBar();

        SP = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());

        rvActivities = (RecyclerView) findViewById(R.id.rvActivities);

        String url =
                SP.getString("server_settings_address", "") +
                "/api_data?apikey=" +
                SP.getString("server_settings_apikey", "") +
                "&cmd=getActivities";

        GsonRequest<ActivityModels.ResponseParent> request = new GsonRequest<>(
                url,
                ActivityModels.ResponseParent.class,
                null,
                requestListener(),
                errorListener()
        );

        ApplicationController.getInstance().addToRequestQueue(request);



        rvActivities.setLayoutManager(new LinearLayoutManager(this));
    }

    private Response.ErrorListener errorListener() {
        return null;
    }

    private Response.Listener<ActivityModels.ResponseParent> requestListener() {
        return new Response.Listener<ActivityModels.ResponseParent>() {
            @Override
            public void onResponse(ActivityModels.ResponseParent response) {
                ArrayList<Activity> activities = new ArrayList<>();

                Collections.addAll(activities, response.response.data);

                ActivityAdapter adapter = new ActivityAdapter(activities);

                rvActivities.setAdapter(adapter);
            }
        };
    }

    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.activity);
    }

}
