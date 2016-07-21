package com.williamcomartin.plexpyremote.Adapters;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

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
public class StatisticsPagerAdapter extends FragmentPagerAdapter {

    public StatisticsPagerAdapter(FragmentManager fm) {
        super(fm);
    }

    @Override
    public Fragment getItem(int index) {

        switch (index) {
            case 0:
                // Top Rated fragment activity
                return new MostWatchedTVFragment();
            case 1:
                // Games fragment activity
                return new MostPopularTVFragment();
            case 2:
                // Movies fragment activity
                return new MostWatchedMovieFragment();
            case 3:
                // Movies fragment activity
                return new MostPopularMovieFragment();
            case 4:
                // Movies fragment activity
                return new MostActiveUserFragment();
            case 5:
                // Movies fragment activity
                return new MostActivePlatformFragment();
            case 6:
                // Movies fragment activity
                return new LastWatchedFragment();
        }

        return null;
    }

    @Override
    public int getCount() {
        // get item count - equal to number of tabs
        return 7;
    }
}
