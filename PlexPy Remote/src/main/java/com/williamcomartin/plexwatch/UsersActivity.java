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

        String url =
                SP.getString("server_settings_address", "") +
                "/api_data?apikey=" +
                SP.getString("server_settings_apikey", "") +
                "&cmd=getUsers" +
                "&json_data={\"draw\":1,\"columns\":[{\"data\":\"friendly_name\",\"name\":\"\",\"searchable\":true,\"orderable\":true,\"search\":{\"value\":\"\",\"regex\":false}}],\"order\":[{\"column\":0,\"dir\":\"asc\"}],\"start\":0,\"length\":100,\"search\":{\"value\":\"\",\"regex\":false}}";

        RequestQueue queue = ApplicationController.getInstance().getRequestQueue();
        GsonRequest<UserModels.UserResponse> request = new GsonRequest<>(
                url,
                UserModels.UserResponse.class,
                null,
                requestListener(),
                errorListener()
        );

        queue.add(request);

        rvUsers.setLayoutManager(new LinearLayoutManager(this));
    }

    private Response.ErrorListener errorListener() {
        return null;
    }

    private Response.Listener<UserModels.UserResponse> requestListener() {
        return new Response.Listener<UserModels.UserResponse>() {
            @Override
            public void onResponse(UserModels.UserResponse response) {
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
