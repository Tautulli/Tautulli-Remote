package com.williamcomartin.plexpyremote;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.Adapters.HistoryAdapter;
import com.williamcomartin.plexpyremote.Helpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Models.HistoryModels;

public class HistoryActivity extends NavBaseActivity {

    private SharedPreferences SP;
    private RecyclerView rvHistory;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_history);
        setupActionBar();

        rvHistory = (RecyclerView) findViewById(R.id.rvHistory);

        SP = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());

        String url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_history";

        GsonRequest<HistoryModels> request = new GsonRequest<>(
                url,
                HistoryModels.class,
                null,
                requestListener(),
                errorListener()
        );

        ApplicationController.getInstance().addToRequestQueue(request);

        rvHistory.setLayoutManager(new LinearLayoutManager(this));
    }

    private Response.ErrorListener errorListener() {
        return new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.d("HistoryActivity", error.toString());
            }
        };
    }

    private Response.Listener<HistoryModels> requestListener() {
        return new Response.Listener<HistoryModels>() {
            @Override
            public void onResponse(HistoryModels response) {
                Log.d("HistoryActivity", response.toString());

                HistoryAdapter adapter = new HistoryAdapter(response.response.data.data);
                rvHistory.setAdapter(adapter);
            }
        };
    }

    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.history);
    }
}
