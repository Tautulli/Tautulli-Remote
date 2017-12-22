package com.williamcomartin.plexpyremote;

import android.app.FragmentTransaction;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.GravityCompat;
import android.support.v7.app.ActionBar;
import android.widget.LinearLayout;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;
import com.williamcomartin.plexpyremote.Models.StatisticsModels;

import java.net.MalformedURLException;

public class StatisticsActivity extends NavBaseActivity {

    private FragmentTransaction fragmentTransaction = getFragmentManager().beginTransaction();
    private LinearLayout linearLayout;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if(!UrlHelpers.hasServer()){
            onBackPressed();
        }
        setContentView(R.layout.activity_statistics);

        setupActionBar();

        linearLayout = (LinearLayout) findViewById(R.id.statistics_linear_layout);

        fetchStatistics();
    }

    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.statistics);
    }

    private void fetchStatistics() {
        try {
            String url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_home_stats";

            GsonRequest<StatisticsModels> request = new GsonRequest<>(
                    url,
                    StatisticsModels.class,
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
            }
        };
    }

    private Response.Listener<StatisticsModels> requestListener() {
        return new Response.Listener<StatisticsModels>() {
            @Override
            public void onResponse(StatisticsModels response) {
                linearLayout.removeAllViewsInLayout();
                addStatsFragment("Most Watched TV", response.response.FindStat("top_tv"));
                addStatsFragment("Most Popular TV", response.response.FindStat("popular_tv"));
                addStatsFragment("Most Watched Movie", response.response.FindStat("top_movies"));
                addStatsFragment("Most Popular Movie", response.response.FindStat("popular_movies"));
                addStatsFragment("Most Active User", response.response.FindStat("top_users"));
                addStatsFragment("Most Active Platform", response.response.FindStat("top_platforms"));

                fragmentTransaction.commit();
            }
        };
    }

    private void addStatsFragment(String type, StatisticsModels.StatisticsGroup group) {
        StatisticsFragment frag = new StatisticsFragment();
        frag.setType(type);
        frag.setStats(group);
        fragmentTransaction.add(linearLayout.getId(), frag);
    }

    @Override
    public void onBackPressed() {
        if (mainDrawerLayout != null && mainDrawerLayout.isDrawerOpen(GravityCompat.START)) {
            super.onBackPressed();
            return;
        }

        Intent intent = new Intent(this, ActivityActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
    }
}
