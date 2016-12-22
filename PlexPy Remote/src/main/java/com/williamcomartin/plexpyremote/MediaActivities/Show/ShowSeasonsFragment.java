package com.williamcomartin.plexpyremote.MediaActivities.Show;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.GridView;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;
import com.williamcomartin.plexpyremote.Models.LibraryMediaModels;
import com.williamcomartin.plexpyremote.R;

import java.util.ArrayList;

/**
 * Created by wcomartin on 2016-12-14.
 */

public class ShowSeasonsFragment extends Fragment {
    private View view;
    private String ratingKey;

    private GridView vSeasonsGrid;
    private ShowSeasonsGridAdapter gridAdapter;

    public ShowSeasonsFragment() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        view = inflater.inflate(R.layout.fragment_show_seasons, container, false);

        gridAdapter = new ShowSeasonsGridAdapter(this.getContext(), new ArrayList<LibraryMediaModels.LibraryMediaItem>());

        vSeasonsGrid = (GridView) view.findViewById(R.id.show_seasons_grid);
        vSeasonsGrid.setAdapter(gridAdapter);

        fetchProfile();

        return view;
    }

    public void setRatingKey(String ratingKey) {
        this.ratingKey = ratingKey;
    }

    private void fetchProfile(){
        String url = "";
        try {
            url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_library_media_info&length=1000&rating_key=" + ratingKey;
        } catch (NoServerException e) {
            e.printStackTrace();
        }
        Log.d("ShowSeasonsFrag", url);
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
                Log.d("ShowSeasonFrag", error.getMessage());
            }
        };
    }

    private Response.Listener<LibraryMediaModels> requestListener() {
        return new Response.Listener<LibraryMediaModels>() {
            @Override
            public void onResponse(LibraryMediaModels response) {
                Log.d("ShowSeasonFrag", response.toString());
                gridAdapter.setSeasons(response.response.data.data);
            }
        };
    }
}
