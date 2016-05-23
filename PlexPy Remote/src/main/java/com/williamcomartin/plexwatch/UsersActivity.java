package com.williamcomartin.plexwatch;

import android.app.Activity;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexwatch.Adapters.ActivityAdapter;
import com.williamcomartin.plexwatch.Adapters.UserAdapter;
import com.williamcomartin.plexwatch.Helpers.GsonRequest;
import com.williamcomartin.plexwatch.Models.ActivityModels;
import com.williamcomartin.plexwatch.Models.UserModels;

import java.util.ArrayList;
import java.util.Collections;

public class UsersActivity extends NavBaseActivity {

    private SharedPreferences SP;
    private RecyclerView rvUsers;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_users);
        setupActionBar();

        SP = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());

        rvUsers = (RecyclerView) findViewById(R.id.rvUsers);

        String url = SP.getString("server_settings_address", "") + "/api/v2?apikey=" + SP.getString("server_settings_apikey", "") + "&cmd=get_users_table";
        GsonRequest<UserModels> request = new GsonRequest<>(
                url,
                UserModels.class,
                null,
                requestListener(),
                errorListener()
        );

        ApplicationController.getInstance().addToRequestQueue(request);

        rvUsers.setLayoutManager(new LinearLayoutManager(this));
    }

    private Response.ErrorListener errorListener() {
        return new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
            }
        };
    }

    private Response.Listener<UserModels> requestListener() {
        return new Response.Listener<UserModels>() {
            @Override
            public void onResponse(UserModels response) {
                UserAdapter adapter = new UserAdapter(response.response.data.data);
                rvUsers.setAdapter(adapter);
            }
        };
    }


    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.users);
    }
}
