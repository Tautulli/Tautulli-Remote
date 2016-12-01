package com.williamcomartin.plexpyremote.WatchStatisticsFragments;

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
import com.williamcomartin.plexpyremote.Adapters.WatchStatistics.MostActiveUserAdapter;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Helpers.GsonRequest;
import com.williamcomartin.plexpyremote.Models.StatisticsModels;
import com.williamcomartin.plexpyremote.R;

public class MostActiveUserFragment extends Fragment {

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
                StatisticsModels.StatisticsGroup group = response.response.FindStat("top_users");
                if(group == null) return;

                MostActiveUserAdapter adapter = new MostActiveUserAdapter(group.rows);
                rvStat.setAdapter(adapter);
            }
        };
    }
}
