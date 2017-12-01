package com.williamcomartin.plexpyremote.SharedFragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.Adapters.HistoryAdapter;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.StringHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;
import com.williamcomartin.plexpyremote.Models.HistoryModels;
import com.williamcomartin.plexpyremote.R;

import java.net.MalformedURLException;
import java.util.ArrayList;

public class HistoryFragment extends Fragment {

    private RecyclerView mHistoryRecyclerView;

    private String mLatestUrl;
    private EditText mSearchField;

    public HistoryFragment() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_history, container, false);

        mHistoryRecyclerView = (RecyclerView) view.findViewById(R.id.shared_history_rv);
        mHistoryRecyclerView.setLayoutManager(new LinearLayoutManager(this.getContext()));
        mHistoryRecyclerView.setAdapter(new HistoryAdapter(this.getContext(), new ArrayList<HistoryModels.HistoryRecord>()));

        mSearchField = (EditText) view.findViewById(R.id.shared_history_search);
        mSearchField.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int start, int count, int after) {

            }

            @Override
            public void afterTextChanged(Editable editable) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int start, int before, int count) {
                Log.d("HistoryFragment", charSequence.toString());
                if(charSequence.length() != 0){
                    fetchData(mLatestUrl, charSequence.toString());
                }
            }
        });

        return view;
    }

    public void setGlobal() {
        try {
            String url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_history";
            fetchData(url);
        } catch (NoServerException | MalformedURLException e) {
            e.printStackTrace();
        }
    }

    public void setUserID(String userID) {
        try {
            String url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_history&user_id=" + userID;
            fetchData(url);
        } catch (NoServerException | MalformedURLException e) {
            e.printStackTrace();
        }
    }

    public void setLibraryId(String libraryId){
        try {
            String url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_history&section_id=" + libraryId;
            fetchData(url);
        } catch (NoServerException | MalformedURLException e) {
            e.printStackTrace();
        }
    }

    public void setRatingKey(String ratingKey){
        try {
            String url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_history&rating_key=" + ratingKey;
            fetchData(url);
        } catch (NoServerException | MalformedURLException e) {
            e.printStackTrace();
        }
    }

    public void setParentRatingKey(String ratingKey){
        try {
            String url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_history&parent_rating_key=" + ratingKey;
            fetchData(url);
        } catch (NoServerException | MalformedURLException e) {
            e.printStackTrace();
        }
    }

    public void setGrandParentRatingKey(String ratingKey){
        try {
            String url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_history&grandparent_rating_key=" + ratingKey;
            fetchData(url);
        } catch (NoServerException | MalformedURLException e) {
            e.printStackTrace();
        }
    }

    private void fetchData (String url) {
        fetchData(url, null);
    }

    private void fetchData (String url, String search) {
        mLatestUrl = url;
        Log.d("HistoryFragment", url);

        String requestUrl = !StringHelpers.isNullOrWhiteSpace(search)
                ? String.format("%s&search=%s", url, search)
                : url;

        Log.d("HistoryFragment", requestUrl);

        GsonRequest<HistoryModels> request = new GsonRequest<>(
                requestUrl,
                HistoryModels.class,
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

    private Response.Listener<HistoryModels> requestListener() {
        return new Response.Listener<HistoryModels>() {
            @Override
            public void onResponse(HistoryModels response) {
                HistoryAdapter adapter = (HistoryAdapter) mHistoryRecyclerView.getAdapter();
                adapter.setHistory(response.response.data.data);
            }
        };
    }

}
