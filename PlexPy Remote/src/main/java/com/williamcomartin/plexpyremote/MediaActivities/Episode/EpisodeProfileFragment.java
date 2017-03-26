package com.williamcomartin.plexpyremote.MediaActivities.Episode;

import android.content.Context;
import android.databinding.DataBindingUtil;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.NetworkImageView;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.ImageCacheManager;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;
import com.williamcomartin.plexpyremote.MediaActivities.Show.ShowProfileModels;
import com.williamcomartin.plexpyremote.R;
import com.williamcomartin.plexpyremote.databinding.FragmentEpisodeProfileBinding;

import java.net.MalformedURLException;

/**
 * Created by wcomartin on 2016-12-14.
 */

public class EpisodeProfileFragment extends Fragment {

    private FragmentEpisodeProfileBinding binding;

    private View view;
    private String ratingKey;

    private NetworkImageView vImage;

    private Context context;

    public EpisodeProfileFragment() {}

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Fancy new binding :)
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_episode_profile,
                container, false);
        view = binding.getRoot();

        vImage = (NetworkImageView) view.findViewById(R.id.episode_profile_image);

        context = this.getContext();

        fetchProfile();
        return view;
    }

    public void setRatingKey(String ratingKey) {
        this.ratingKey = ratingKey;
    }

    private void fetchProfile(){
        try {
            Uri.Builder builder = UrlHelpers.getUriBuilder();
            builder.appendQueryParameter("cmd", "get_metadata");
            builder.appendQueryParameter("rating_key", ratingKey);

            GsonRequest<ShowProfileModels> request = new GsonRequest<>(
                    builder.toString(),
                    ShowProfileModels.class,
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

    private Response.Listener<ShowProfileModels> requestListener() {
        return new Response.Listener<ShowProfileModels>() {
            @Override
            public void onResponse(ShowProfileModels response) {

                ShowProfileModels.Data item;
                if(response.response.data.metadata != null) item = response.response.data.metadata;
                else item = response.response.data;

                binding.setEpisode(item);

                vImage.setImageUrl(UrlHelpers.getImageUrl(item.art, "4000", "6000"),
                        ImageCacheManager.getInstance().getImageLoader());

            }
        };
    }
}
