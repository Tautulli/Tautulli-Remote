package com.williamcomartin.plexpyremote.MediaActivities.Season;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import com.williamcomartin.plexpyremote.MediaActivities.Movie.MovieProfileFragment;
import com.williamcomartin.plexpyremote.SharedFragments.HistoryFragment;

public class SeasonPagerAdapter extends FragmentStatePagerAdapter {

    private final String[] tabNames = {"Episodes", "History"};

    private final FragmentManager fm;
    private String ratingKey;

    public SeasonPagerAdapter(FragmentManager fm, String ratingKey) {
        super(fm);

        this.fm = fm;
        this.ratingKey = ratingKey;
    }

    @Override
    public Fragment getItem(int index) {
        switch (index) {
            case 0:
                SeasonEpisodesFragment episodesFrag = new SeasonEpisodesFragment();
                episodesFrag.setRatingKey(ratingKey);
                return episodesFrag;
            case 1:
                HistoryFragment historyFrag = new HistoryFragment();
                historyFrag.setParentRatingKey(ratingKey);
                return historyFrag;
        }
        return null;
    }

    @Override
    public CharSequence getPageTitle(int position) {
        return tabNames[position];
    }

    @Override
    public int getCount() {
        return tabNames.length;
    }
}
