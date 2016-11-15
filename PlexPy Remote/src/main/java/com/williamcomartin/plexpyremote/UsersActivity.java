package com.williamcomartin.plexpyremote;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.Adapters.UserAdapter;
import com.williamcomartin.plexpyremote.Helpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Models.UserModels;

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

        String url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_users_table";
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
                UserAdapter adapter = new UserAdapter(response.response.data.data, new UserAdapter.OnItemClickListener() {
                    @Override
                    public void onItemClick(UserModels.User item) {
                        Intent intent = new Intent(getApplicationContext(), UserDetailActivity.class);
                        intent.putExtra("ID", item.userId);
                        intent.putExtra("NAME", item.friendlyName);
                        startActivity(intent);
                    }
                });
                rvUsers.setAdapter(adapter);
            }
        };
    }


    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.users);
    }
}
