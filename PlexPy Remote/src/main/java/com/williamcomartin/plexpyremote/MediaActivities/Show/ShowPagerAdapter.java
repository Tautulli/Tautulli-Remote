package com.williamcomartin.plexpyremote.MediaActivities.Show;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import com.williamcomartin.plexpyremote.SharedFragments.HistoryFragment;

public class ShowPagerAdapter extends FragmentStatePagerAdapter {

    private final String[] tabNames = {"Profile", "Seasons", "History"};

    private final FragmentManager fm;
    private String ratingKey;

    public ShowPagerAdapter(FragmentManager fm, String ratingKey) {
        super(fm);

        this.fm = fm;
        this.ratingKey = ratingKey;
    }

    @Override
    public Fragment getItem(int index) {
        switch (index) {
            case 0:
                ShowProfileFragment profileFrag = new ShowProfileFragment();
                profileFrag.setRatingKey(ratingKey);
                return profileFrag;
            case 1:
                ShowSeasonsFragment seasonsFrag = new ShowSeasonsFragment();
                seasonsFrag.setRatingKey(ratingKey);
                return seasonsFrag;
            case 2:
                HistoryFragment historyFrag = new HistoryFragment();
                historyFrag.setGrandParentRatingKey(ratingKey);
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
