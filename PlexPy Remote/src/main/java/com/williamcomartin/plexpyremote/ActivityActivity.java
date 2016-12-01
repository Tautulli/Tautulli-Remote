package com.williamcomartin.plexpyremote;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.content.IntentCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v4.content.ContextCompat;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.LinearLayoutManager;
import android.util.Log;
import android.view.View;
import android.widget.TextView;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.Adapters.ActivityAdapter;
import com.williamcomartin.plexpyremote.Helpers.EmptyRecyclerView;
import com.williamcomartin.plexpyremote.Helpers.ErrorListener;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Models.ActivityModels;

import java.util.Timer;
import java.util.TimerTask;

import java.util.ArrayList;

public class ActivityActivity extends NavBaseActivity {

    private final Context context = this;
    private EmptyRecyclerView rvActivities;
    private ActivityAdapter adapter;
    private SharedPreferences SP;
    private Timer myTimer = new Timer();

    private DrawerLayout mDrawerLayout;

    private SwipeRefreshLayout mSwipeRefreshLayout;

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

        mDrawerLayout = (DrawerLayout) findViewById(R.id.activity_drawer);
        mDrawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED);
        mDrawerLayout.addDrawerListener(new DrawerLayout.DrawerListener() {
            @Override
            public void onDrawerSlide(View drawerView, float slideOffset) {

            }

            @Override
            public void onDrawerOpened(View drawerView) {
                mDrawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_UNLOCKED);
            }

            @Override
            public void onDrawerClosed(View drawerView) {
                mDrawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED);
            }

            @Override
            public void onDrawerStateChanged(int newState) {

            }
        });

        rvActivities = (EmptyRecyclerView) findViewById(R.id.rvActivities);
        rvActivities.setEmptyView(findViewById(R.id.emptyRvActivities));
        adapter = new ActivityAdapter(this, getSupportFragmentManager());
        adapter.setActivityView(this);
        rvActivities.setAdapter(adapter);
        rvActivities.setLayoutManager(new LinearLayoutManager(this));

        mSwipeRefreshLayout = (SwipeRefreshLayout) findViewById(R.id.swipeRefreshLayoutActivities);
        mSwipeRefreshLayout.setOnRefreshListener(refreshListener);

        mSwipeRefreshLayout.setRefreshing(true);
        refreshItems();

        SP = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());
        int refreshPeriod;
        String refreshString = SP.getString("app_settings_refresh", "0");
        try {
            refreshPeriod = Integer.parseInt(refreshString);
        } catch (NumberFormatException e) {
            refreshPeriod = 0;
        }
        refreshPeriod = refreshPeriod * 1000;

        if (refreshPeriod > 0) {
            myTimer.schedule(new TimerTask() {
                @Override
                public void run() {
                    refreshItems();
                }
            }, 0, refreshPeriod);
        }
    }

    @Override
    protected void onPause() {
        super.onPause();
        mDrawerLayout.closeDrawers();
    }

    private void refreshItems() {

        try {
            GsonRequest<ActivityModels> request = new GsonRequest<>(
                    UrlHelpers.getHostPlusAPIKey() + "&cmd=get_activity",
                    ActivityModels.class,
                    null,
                    requestListener(),
                    errorListener()
            );

            ApplicationController.getInstance().addToRequestQueue(request);
        } catch (NoServerException e) {
            TextView text = (TextView) findViewById(R.id.emptyTextView);
            text.setText(getString(R.string.InvalidServer));
            text.setTextColor(ContextCompat.getColor(context, R.color.colorAccent));
            findViewById(R.id.oopsView).setVisibility(View.VISIBLE);
            adapter.SetActivities(new ArrayList<ActivityModels.Activity>());
        }


    }

    private void onItemsLoadComplete() {
        if (mSwipeRefreshLayout != null) {
            mSwipeRefreshLayout.setRefreshing(false);
        }
    }

    private Response.ErrorListener errorListener() {
        return new ErrorListener(this) {
            @Override
            public void onErrorResponse(VolleyError error) {
                super.onErrorResponse(error);
                TextView text = (TextView) findViewById(R.id.emptyTextView);
                if (error.getMessage() != null) {
                    if (error.getMessage().contains("No address associated with hostname")) {
                        text.setText(getString(R.string.InvalidServer));
                    } else if (error.getMessage().contains("JsonSyntaxException")) {
                        text.setText(getString(R.string.InvalidServer));
                    } else if (error.getMessage().contains("Bad url")) {
                        text.setText(getString(R.string.InvalidServer));
                    } else if (error.getMessage().contains("Network is unreachable")) {
                        text.setText(getString(R.string.NetworkUnreachable));
                    } else if (error.getMessage().contains("Connection refused")) {
                        text.setText(getString(R.string.ConnectionRefused));
                    } else {
                        text.setText(getString(R.string.UnexpectedError) + ", " + error.getMessage());
                    }
                } else {
                    text.setText(getString(R.string.InvalidTimeoutServer));
                }
                text.setTextColor(ContextCompat.getColor(context, R.color.colorAccent));
                findViewById(R.id.oopsView).setVisibility(View.VISIBLE);
                adapter.SetActivities(new ArrayList<ActivityModels.Activity>());
                onItemsLoadComplete();
            }
        };
    }

    private Response.Listener<ActivityModels> requestListener() {
        return new Response.Listener<ActivityModels>() {
            @Override
            public void onResponse(ActivityModels response) {
                if (response.response.data.sessions != null) {
                    adapter.SetActivities(response.response.data.sessions);
                } else if (response.response.message.equals("Invalid apikey")) {
                    TextView text = (TextView) findViewById(R.id.emptyTextView);
                    text.setText(getString(R.string.InvalidAPIKey));
                    text.setTextColor(ContextCompat.getColor(context, R.color.colorAccent));
                    findViewById(R.id.oopsView).setVisibility(View.VISIBLE);
                    adapter.SetActivities(new ArrayList<ActivityModels.Activity>());
                } else {
                    TextView text = (TextView) findViewById(R.id.emptyTextView);
                    text.setText(getString(R.string.NoActivity));
                    findViewById(R.id.oopsView).setVisibility(View.GONE);
                    adapter.SetActivities(new ArrayList<ActivityModels.Activity>());
                }
                onItemsLoadComplete();
            }
        };
    }


    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.activity);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        myTimer.cancel();
    }
}
