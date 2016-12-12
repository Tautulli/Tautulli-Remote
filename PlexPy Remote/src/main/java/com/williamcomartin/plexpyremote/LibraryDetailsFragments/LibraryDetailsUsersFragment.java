package com.williamcomartin.plexpyremote.LibraryDetailsFragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.williamcomartin.plexpyremote.Adapters.UserTopStatAdapter;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.ExpandableHeightGridView;
import com.williamcomartin.plexpyremote.Models.LibraryUsersStatsModels;
import com.williamcomartin.plexpyremote.R;

import java.util.ArrayList;
import java.util.List;

public class LibraryDetailsUsersFragment extends Fragment {

    ExpandableHeightGridView mGridView;

    public LibraryDetailsUsersFragment() {

    }

    public void setUsersStats(List<LibraryUsersStatsModels.LibraryUsersStat> data){
        UserTopStatAdapter adapter = (UserTopStatAdapter) mGridView.getAdapter();
        adapter.setUsers(data);
        adapter.notifyDataSetChanged();
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View view = inflater.inflate(R.layout.fragment_library_details_users, container, false);

        mGridView = (ExpandableHeightGridView) view.findViewById(R.id.library_details_user_grid);
        mGridView.setExpanded(true);
        mGridView.setAdapter(new UserTopStatAdapter(this.getContext(), new ArrayList<LibraryUsersStatsModels.LibraryUsersStat>()));

        return view;
    }
}
