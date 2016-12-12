package com.williamcomartin.plexpyremote.Adapters;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.app.FragmentStatePagerAdapter;
import android.util.Log;

import com.williamcomartin.plexpyremote.LibraryDetailsFragments.LibraryDetailsMediaFragment;
import com.williamcomartin.plexpyremote.LibraryDetailsFragments.LibraryDetailsStatsFragment;
import com.williamcomartin.plexpyremote.SharedFragments.HistoryFragment;
import com.williamcomartin.plexpyremote.SharedFragments.RecentlyAddedFragment;

public class LibraryDetailsPagerAdapter extends FragmentStatePagerAdapter {

    private final FragmentManager fm;
    private final String libraryId;

    public LibraryDetailsPagerAdapter(FragmentManager fm, String libraryId) {
        super(fm);

        this.fm = fm;
        this.libraryId = libraryId;
    }

    @Override
    public Fragment getItem(int index) {
        switch (index) {
            case 0:
                LibraryDetailsStatsFragment statsFrag = new LibraryDetailsStatsFragment();
                statsFrag.setLibraryId(libraryId);
                return statsFrag;

            case 1:
                HistoryFragment historyFrag = new HistoryFragment();
                historyFrag.setLibraryId(libraryId);
                return historyFrag;

            case 2:
                RecentlyAddedFragment newFrag = new RecentlyAddedFragment();
                newFrag.setLibraryId(libraryId);
                return newFrag;

            case 3:
                LibraryDetailsMediaFragment mediaFrag = new LibraryDetailsMediaFragment();
                mediaFrag.setLibraryId(libraryId);
                return mediaFrag;
        }

        return null;
    }

    @Override
    public CharSequence getPageTitle(int position) {
        String[] tabNames = {
                "Stats",
                "History",
                "New",
                "Media"
        };
        return tabNames[position];
    }

    @Override
    public int getCount() {
        return 4;
    }
}
