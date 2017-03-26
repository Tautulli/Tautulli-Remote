package com.williamcomartin.plexpyremote.MediaActivities.Episode;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import com.williamcomartin.plexpyremote.SharedFragments.HistoryFragment;

public class EpisodePagerAdapter extends FragmentStatePagerAdapter {

    private final String[] tabNames = {"Profile", "History"};

    private final FragmentManager fm;
    private String ratingKey;

    public EpisodePagerAdapter(FragmentManager fm, String ratingKey) {
        super(fm);

        this.fm = fm;
        this.ratingKey = ratingKey;
    }

    @Override
    public Fragment getItem(int index) {
        switch (index) {
            case 0:
                EpisodeProfileFragment profileFrag = new EpisodeProfileFragment();
                profileFrag.setRatingKey(ratingKey);
                return profileFrag;
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
