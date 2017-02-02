package com.williamcomartin.plexpyremote.SharedFragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.Adapters.RecentlyAddedAdapter;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Helpers.EndlessScrollListener;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;
import com.williamcomartin.plexpyremote.Models.RecentlyAddedModels;
import com.williamcomartin.plexpyremote.R;

import java.net.MalformedURLException;
import java.util.ArrayList;

public class RecentlyAddedFragment extends Fragment {

    private RecyclerView mRecentlyAddedRecyclerView;
    private String libraryId;

    public RecentlyAddedFragment() {}

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_recently_added, container, false);

        mRecentlyAddedRecyclerView = (RecyclerView) view.findViewById(R.id.shared_recently_added_rv);
        LinearLayoutManager layoutManager = new LinearLayoutManager(this.getContext());
        mRecentlyAddedRecyclerView.setLayoutManager(layoutManager);
        mRecentlyAddedRecyclerView.setAdapter(new RecentlyAddedAdapter(new ArrayList<RecentlyAddedModels.RecentItem>()));

        mRecentlyAddedRecyclerView.setOnScrollListener(new EndlessScrollListener(layoutManager) {
            @Override
            public void onLoadMore(int current_page) {
                try {
                    String url = UrlHelpers.getHostPlusAPIKey()
                            + "&cmd=get_recently_added&count=10&section_id="
                            + libraryId + "&start=" + String.valueOf(current_page * 10);
                    fetchData(url);
                } catch (NoServerException | MalformedURLException e) {
                    e.printStackTrace();
                }
            }
        });

        return view;
    }

    public void setLibraryId(String libraryId){
        this.libraryId = libraryId;
        try {
            String url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_recently_added&count=10&section_id=" + libraryId;
            fetchData(url);
        } catch (NoServerException | MalformedURLException e) {
            e.printStackTrace();
        }
    }

    private void fetchData (String url){
        GsonRequest<RecentlyAddedModels> request = new GsonRequest<>(
                url,
                RecentlyAddedModels.class,
                null,
                requestListener(),
                errorListener()
        );

        RequestManager.addToRequestQueue(request);
    }

    private Response.ErrorListener errorListener() {
        return new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
            }
        };
    }

    private Response.Listener<RecentlyAddedModels> requestListener() {
        return new Response.Listener<RecentlyAddedModels>() {
            @Override
            public void onResponse(RecentlyAddedModels response) {
                RecentlyAddedAdapter adapter = (RecentlyAddedAdapter) mRecentlyAddedRecyclerView.getAdapter();
                adapter.addItems(response.response.data.recentlyAdded);
            }
        };
    }
}
