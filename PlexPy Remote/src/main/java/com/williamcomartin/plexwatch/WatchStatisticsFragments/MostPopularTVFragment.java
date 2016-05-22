package com.williamcomartin.plexwatch.WatchStatisticsFragments;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexwatch.Adapters.WatchStatistics.MostPopularTVAdapter;
import com.williamcomartin.plexwatch.ApplicationController;
import com.williamcomartin.plexwatch.Helpers.GsonRequest;
import com.williamcomartin.plexwatch.Models.StatisticsModels;
import com.williamcomartin.plexwatch.R;

public class MostPopularTVFragment extends Fragment {

    private SharedPreferences SP;
    private RecyclerView rvStat;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_statistics, container, false);


        rvStat = (RecyclerView) view.findViewById(R.id.rvStatistics);

        SP = PreferenceManager.getDefaultSharedPreferences(ApplicationController.getInstance().getApplicationContext());

        String url = SP.getString("server_settings_address", "") + "/api/v2?apikey=" + SP.getString("server_settings_apikey", "") + "&cmd=get_home_stats";

        GsonRequest<StatisticsModels> request = new GsonRequest<>(
                url,
                StatisticsModels.class,
                null,
                requestListener(),
                errorListener()
        );

        ApplicationController.getInstance().addToRequestQueue(request);

        rvStat.setLayoutManager(new LinearLayoutManager(this.getContext()));

        return view;
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
                StatisticsModels.StatisticsGroup group = response.response.FindStat("popular_tv");

                MostPopularTVAdapter adapter = new MostPopularTVAdapter(group.rows);
                rvStat.setAdapter(adapter);
            }
        };
    }

}
