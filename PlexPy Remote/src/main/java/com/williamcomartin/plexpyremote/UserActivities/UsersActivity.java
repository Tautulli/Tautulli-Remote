package com.williamcomartin.plexpyremote.UserActivities;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.view.GravityCompat;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.ActivityActivity;
import com.williamcomartin.plexpyremote.Adapters.UserAdapter;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;
import com.williamcomartin.plexpyremote.Models.UserModels;
import com.williamcomartin.plexpyremote.NavBaseActivity;
import com.williamcomartin.plexpyremote.R;

import java.net.MalformedURLException;

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

        try {
            String url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_users_table&length=10000000";

            GsonRequest<UserModels> request = new GsonRequest<>(
                    url,
                    UserModels.class,
                    null,
                    requestListener(),
                    errorListener()
            );

            RequestManager.addToRequestQueue(request);
        } catch (NoServerException | MalformedURLException e) {
            e.printStackTrace();
        }


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
                        Log.d("UsersActivity", item.userId.toString());
                        Intent intent = new Intent(getApplicationContext(), UserDetailActivity.class);
                        intent.putExtra("UserID", item.userId.toString());
                        intent.putExtra("UserName", item.friendlyName);
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
