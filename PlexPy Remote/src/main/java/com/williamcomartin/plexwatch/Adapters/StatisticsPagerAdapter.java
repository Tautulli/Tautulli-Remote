package com.williamcomartin.plexwatch.Adapters;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;

import com.williamcomartin.plexwatch.WatchStatisticsFragments.MostWatchedTVFragment;

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
                return new MostWatchedTVFragment();
            case 2:
                // Movies fragment activity
                return new MostWatchedTVFragment();
            case 3:
                // Movies fragment activity
                return new MostWatchedTVFragment();
            case 4:
                // Movies fragment activity
                return new MostWatchedTVFragment();
            case 5:
                // Movies fragment activity
                return new MostWatchedTVFragment();
            case 6:
                // Movies fragment activity
                return new MostWatchedTVFragment();
        }

        return null;
    }

    @Override
    public int getCount() {
        // get item count - equal to number of tabs
        return 7;
    }
}
