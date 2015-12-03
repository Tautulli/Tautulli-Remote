package com.williamcomartin.plexwatch;

import android.os.Bundle;
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

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_activity);
        setupActionBar();

        rvActivities = (RecyclerView) findViewById(R.id.rvActivities);

        String url = "http://192.168.1.116:8181/api_data?apikey=c90f2b6909393a8d2f38103d947a67c5&cmd=getActivities";

        RequestQueue queue = ApplicationController.getInstance().getRequestQueue();
        GsonRequest<ActivityModels.ResponseParent> request = new GsonRequest<>(
                url,
                ActivityModels.ResponseParent.class,
                null,
                requestListener(),
                errorListener()
        );

        queue.add(request);



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
