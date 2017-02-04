package com.williamcomartin.plexpyremote;

import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.view.GravityCompat;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.Adapters.RecentlyAddedAdapter;
import com.williamcomartin.plexpyremote.Helpers.EndlessScrollListener;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;
import com.williamcomartin.plexpyremote.Models.RecentlyAddedModels;

import java.net.MalformedURLException;
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

        try {
//            String url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_recently_added&count=10";

            Uri.Builder builder = UrlHelpers.getUriBuilder();
            builder.appendQueryParameter("cmd", "get_recently_added");
            builder.appendQueryParameter("count", "10");

            GsonRequest<RecentlyAddedModels> request = new GsonRequest<>(
                    builder.toString(),
                    RecentlyAddedModels.class,
                    null,
                    requestListener(),
                    errorListener()
            );

            RequestManager.addToRequestQueue(request);
        } catch (NoServerException | MalformedURLException e) {
            e.printStackTrace();
        }


        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this);
        rvActivities.setLayoutManager(linearLayoutManager);

        rvActivities.setOnScrollListener(new EndlessScrollListener(linearLayoutManager) {
            @Override
            public void onLoadMore(int current_page) {
                try {
                    Uri.Builder builder = UrlHelpers.getUriBuilder();
                    builder.appendQueryParameter("cmd", "get_recently_added");
                    builder.appendQueryParameter("count", "10");
                    builder.appendQueryParameter("start", String.valueOf(current_page * 10));

                    GsonRequest<RecentlyAddedModels> request = new GsonRequest<>(
                            builder.toString(),
                            RecentlyAddedModels.class,
                            null,
                            requestListener(),
                            errorListener()
                    );

                    RequestManager.addToRequestQueue(request);
                } catch (NoServerException | MalformedURLException e) {
                    e.printStackTrace();
                }


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

    @Override
    public void onBackPressed() {
        if (mainDrawerLayout.isDrawerOpen(GravityCompat.START)) {
            super.onBackPressed();
            return;
        }

        Intent intent = new Intent(this, ActivityActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
    }
}
