package com.williamcomartin.plexpyremote;

import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.Adapters.ActivityAdapter;
import com.williamcomartin.plexpyremote.Helpers.EmptyRecyclerView;
import com.williamcomartin.plexpyremote.Helpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Models.ActivityModels;

public class ActivityActivity extends NavBaseActivity {

    private EmptyRecyclerView rvActivities;
    private ActivityAdapter adapter;

    private SwipeRefreshLayout mSwipeRefreshLayout;
    private SwipeRefreshLayout mSwipeRefreshLayout2;

    private SwipeRefreshLayout.OnRefreshListener refreshListener = new SwipeRefreshLayout.OnRefreshListener() {
        @Override
        public void onRefresh() {
            refreshItems();
        }
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_activity);
        setupActionBar();

        rvActivities = (EmptyRecyclerView) findViewById(R.id.rvActivities);
        adapter = new ActivityAdapter();
        rvActivities.setAdapter(adapter);
        rvActivities.setLayoutManager(new LinearLayoutManager(this));

        View emptyView = findViewById(R.id.emptyRvActivities);
        rvActivities.setEmptyView(emptyView);

        refreshItems();

        mSwipeRefreshLayout = (SwipeRefreshLayout) findViewById(R.id.swipeRefreshLayoutActivities);
        mSwipeRefreshLayout.setOnRefreshListener(refreshListener);

        mSwipeRefreshLayout2 = (SwipeRefreshLayout) findViewById(R.id.swipeRefreshLayoutActivities2);
        mSwipeRefreshLayout2.setOnRefreshListener(refreshListener);
    }


    private void refreshItems() {
        GsonRequest<ActivityModels> request = new GsonRequest<>(
                UrlHelpers.getHostPlusAPIKey() + "&cmd=get_activity",
                ActivityModels.class,
                null,
                requestListener(),
                errorListener()
        );

        ApplicationController.getInstance().addToRequestQueue(request);
    }

    private void onItemsLoadComplete() {
        if (mSwipeRefreshLayout != null) {
            mSwipeRefreshLayout.setRefreshing(false);
        }
        if (mSwipeRefreshLayout2 != null) {
            mSwipeRefreshLayout2.setRefreshing(false);
        }
    }

    private Response.ErrorListener errorListener() {
        onItemsLoadComplete();
        return new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                TextView text = (TextView) findViewById(R.id.emptyTextView);
                text.setText(error.getMessage());
                text.setTextColor(Color.RED);
                ImageView errorImage = (ImageView) findViewById(R.id.errorImageView);
                errorImage.setVisibility(View.VISIBLE);
            }
        };
    }

    private Response.Listener<ActivityModels> requestListener() {
        return new Response.Listener<ActivityModels>() {
            @Override
            public void onResponse(ActivityModels response) {
                adapter.SetActivities(response.response.data.sessions);
                onItemsLoadComplete();
            }
        };
    }


    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.activity);
    }

}
