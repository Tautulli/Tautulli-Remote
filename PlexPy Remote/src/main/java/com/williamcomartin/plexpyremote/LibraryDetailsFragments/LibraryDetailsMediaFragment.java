package com.williamcomartin.plexpyremote.LibraryDetailsFragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.Adapters.LibraryDetailsMediaListAdapter;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;
import com.williamcomartin.plexpyremote.Models.LibraryMediaModels;
import com.williamcomartin.plexpyremote.R;

public class LibraryDetailsMediaFragment extends Fragment {

    private String libraryId;
    private RecyclerView mMediaListRecyclerView;
//    private VerticalRecyclerViewFastScroller mMediaListRecyclerFastScroller;
//    private SectionTitleIndicator mMediaListRecyclerFastScrollerIndicator;

    public LibraryDetailsMediaFragment() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_library_details_media, container, false);

        mMediaListRecyclerView = (RecyclerView) view.findViewById(R.id.library_details_media_list);

        mMediaListRecyclerView.setLayoutManager(new LinearLayoutManager(this.getContext()));
        mMediaListRecyclerView.setAdapter(new LibraryDetailsMediaListAdapter(this.getContext()));

        return view;
    }

    public void setLibraryId(String libraryId){
        this.libraryId = libraryId;
        try {
            String url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_library_media_info&length=100000000000&section_id=" + libraryId;
            fetchData(url);
        } catch (NoServerException e) {
            e.printStackTrace();
        }
    }

    private void fetchData (String url){
        GsonRequest<LibraryMediaModels> request = new GsonRequest<>(
                url,
                LibraryMediaModels.class,
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

    private Response.Listener<LibraryMediaModels> requestListener() {
        return new Response.Listener<LibraryMediaModels>() {
            @Override
            public void onResponse(LibraryMediaModels response) {
                LibraryDetailsMediaListAdapter adapter = (LibraryDetailsMediaListAdapter) mMediaListRecyclerView.getAdapter();
                adapter.addItems(response.response.data.data);
            }
        };
    }

}
