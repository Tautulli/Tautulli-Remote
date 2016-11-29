package com.williamcomartin.plexpyremote.Adapters;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.williamcomartin.plexpyremote.LibraryDetailsFragments.LibraryDetailsProfileFragment;
import com.williamcomartin.plexpyremote.WatchStatisticsFragments.LastWatchedFragment;
import com.williamcomartin.plexpyremote.WatchStatisticsFragments.MostActivePlatformFragment;
import com.williamcomartin.plexpyremote.WatchStatisticsFragments.MostActiveUserFragment;
import com.williamcomartin.plexpyremote.WatchStatisticsFragments.MostPopularMovieFragment;
import com.williamcomartin.plexpyremote.WatchStatisticsFragments.MostPopularTVFragment;
import com.williamcomartin.plexpyremote.WatchStatisticsFragments.MostWatchedMovieFragment;
import com.williamcomartin.plexpyremote.WatchStatisticsFragments.MostWatchedTVFragment;

/**
 * Created by wcomartin on 2015-11-19.
 */
public class LibraryDetailsPagerAdapter extends FragmentPagerAdapter {

    public LibraryDetailsPagerAdapter(FragmentManager fm) {
        super(fm);
    }

    @Override
    public Fragment getItem(int index) {

        switch (index) {
            case 0:
            // Top Rated fragment activity
            return new LibraryDetailsProfileFragment();
        }

        return null;
    }

    @Override
    public int getCount() {
        // get item count - equal to number of tabs
        return 1;
    }
}
