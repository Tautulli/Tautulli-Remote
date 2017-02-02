package com.williamcomartin.plexpyremote;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.GravityCompat;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.Adapters.LibraryStatisticsAdapter;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;
import com.williamcomartin.plexpyremote.Models.LibraryStatisticsModels;

import java.net.MalformedURLException;

public class LibraryStatisticsActivity extends NavBaseActivity {

    private RecyclerView rvLibStats;
    private final Context context = this;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_library_statistics);
        setupActionBar();

        rvLibStats = (RecyclerView) findViewById(R.id.rvLibStats);
        rvLibStats.setLayoutManager(new LinearLayoutManager(this));

        refreshData();
    }

    private void refreshData () {
        try {
            String url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_libraries";

            GsonRequest<LibraryStatisticsModels> request = new GsonRequest<>(
                    url,
                    LibraryStatisticsModels.class,
                    null,
                    requestListener(),
                    errorListener()
            );

            RequestManager.addToRequestQueue(request);
        } catch (NoServerException | MalformedURLException e) {
            e.printStackTrace();
        }
    }

    private Response.ErrorListener errorListener() {
        return new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                refreshData();
            }
        };
    }

    private Response.Listener<LibraryStatisticsModels> requestListener() {
        return new Response.Listener<LibraryStatisticsModels>() {
            @Override
            public void onResponse(LibraryStatisticsModels response) {
                LibraryStatisticsAdapter adapter = new LibraryStatisticsAdapter(context, response.response.data);
                rvLibStats.setAdapter(adapter);
            }
        };
    }

    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.libraries);
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
