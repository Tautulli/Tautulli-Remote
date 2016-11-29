package com.williamcomartin.plexpyremote.LibraryDetailsFragments;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.GridView;

import com.williamcomartin.plexpyremote.Adapters.UserTopStatAdapter;
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

        return view;
    }
}
