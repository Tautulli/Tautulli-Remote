package com.williamcomartin.plexwatch;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.RecyclerView;
import android.util.Log;

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.williamcomartin.plexwatch.Adapters.HistoryAdapter;
import com.williamcomartin.plexwatch.Helpers.GsonRequest;
import com.williamcomartin.plexwatch.Models.HistoryModels;

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

        String url = SP.getString("server_settings_address", "") +
                "/api_data?apikey=" +
                SP.getString("server_settings_apikey", "") +
                "&cmd=getHistory" +
                "&json_data={\"draw\":4,\"columns\":[{\"data\":\"date\",\"name\":\"\",\"searchable\":false,\"orderable\":true,\"search\":{\"value\":\"\",\"regex\":false}}],\"order\":[{\"column\":0,\"dir\":\"desc\"}],\"start\":0,\"length\":25,\"search\":{\"value\":\"\",\"regex\":false}}";

        GsonRequest<HistoryModels.HistoryResponse> request = new GsonRequest<>(
                url,
                HistoryModels.HistoryResponse.class,
                null,
                requestListener(),
                errorListener()
        );

        ApplicationController.getInstance().addToRequestQueue(request);

    }

    private Response.ErrorListener errorListener() {
        return null;
    }

    private Response.Listener<HistoryModels.HistoryResponse> requestListener() {
        return new Response.Listener<HistoryModels.HistoryResponse>() {
            @Override
            public void onResponse(HistoryModels.HistoryResponse response) {
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
