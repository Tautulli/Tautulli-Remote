package com.williamcomartin.plexpyremote.SharedFragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.Adapters.RecentlyAddedAdapter;
import com.williamcomartin.plexpyremote.Helpers.EndlessScrollListener;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;
import com.williamcomartin.plexpyremote.Models.RecentlyAddedModels;
import com.williamcomartin.plexpyremote.R;

import java.net.MalformedURLException;
import java.util.ArrayList;

public class RecentlyAddedFragment extends Fragment {

    private RecyclerView mRecentlyAddedRecyclerView;
    private String libraryId;

    private String mLatestUrl;

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
                Log.d("RecentlyAddedFragment", String.valueOf(current_page));
                fetchData(mLatestUrl, current_page - 1);
            }
        });

        return view;
    }

    public void setGlobal() {
        try {
            String url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_recently_added&count=10";
            fetchData(url);
        } catch (NoServerException | MalformedURLException e) {
            e.printStackTrace();
        }
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

    private void fetchData (String url) {
        fetchData(url, 0);
    }

    private void fetchData (String url, int page) {
        mLatestUrl = url;
        Log.d("RecentlyAddedFragment", url);
        String requestUrl = String.format("%s&start=%s", url, page * 10);
        Log.d("RecentlyAddedFragment", requestUrl);

        GsonRequest<RecentlyAddedModels> request = new GsonRequest<>(
                requestUrl,
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
