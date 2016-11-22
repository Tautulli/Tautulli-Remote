package com.williamcomartin.plexpyremote;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.android.volley.toolbox.NetworkImageView;
import com.williamcomartin.plexpyremote.Models.ActivityModels;


public class StreamInfoFragment extends Fragment {


    private ActivityModels.Activity mActivity;
    private NetworkImageView vImage;

    public StreamInfoFragment() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_stream_info, container, false);

        vImage = (NetworkImageView) view.findViewById(R.id.activity_stream_thumb);

        return view;
    }

    public void setStreamInfo(ActivityModels.Activity activity) {
        mActivity = activity;
    }
}
