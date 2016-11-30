package com.williamcomartin.plexpyremote.LibraryDetailsFragments;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.GridView;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.Adapters.HistoryAdapter;
import com.williamcomartin.plexpyremote.Adapters.HistoryHorizontalAdapter;
import com.williamcomartin.plexpyremote.Adapters.UserTopStatAdapter;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Models.HistoryModels;
import com.williamcomartin.plexpyremote.R;

public class LibraryDetailsProfileFragment extends Fragment {
    public LibraryDetailsProfileFragment() {
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
        View view =  inflater.inflate(R.layout.fragment_library_details_profile, container, false);

        String[] users = {"William Comartin","William Comartin","William Comartin","William Comartin","William Comartin","William Comartin"};

        GridView userGrid = (GridView) view.findViewById(R.id.library_details_profile_user_grid);
        userGrid.setAdapter(new UserTopStatAdapter(this.getContext(), users));
        userGrid.setVerticalScrollBarEnabled(false);

//        setupRecentlyPlayed(view);

        return view;
    }

    public void setupRecentlyPlayed(View view){
//        final RecyclerView recentlyPlayedRV = (RecyclerView) view.findViewById(R.id.library_details_profile_recently_played_recycler_view);
//        recentlyPlayedRV.setLayoutManager(new LinearLayoutManager(this.getContext(), LinearLayoutManager.HORIZONTAL, false));
//
//        try {
//            String url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_history";
//
//            GsonRequest<HistoryModels> request = new GsonRequest<>(
//                    url,
//                    HistoryModels.class,
//                    null,
//                    new Response.Listener<HistoryModels>() {
//                        @Override
//                        public void onResponse(HistoryModels response) {
//                            HistoryHorizontalAdapter adapter = new HistoryHorizontalAdapter(response.response.data.data);
//                            recentlyPlayedRV.setAdapter(adapter);
//                        }
//                    },
//                    new Response.ErrorListener() {
//                        @Override
//                        public void onErrorResponse(VolleyError error) {
//
//                        }
//                    }
//            );
//
//            ApplicationController.getInstance().addToRequestQueue(request);
//        } catch (NoServerException e) {
//            e.printStackTrace();
//        }
    }
}
