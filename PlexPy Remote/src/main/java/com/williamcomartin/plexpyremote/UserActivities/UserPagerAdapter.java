package com.williamcomartin.plexpyremote.UserActivities;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import com.williamcomartin.plexpyremote.MediaActivities.Show.ShowProfileFragment;
import com.williamcomartin.plexpyremote.MediaActivities.Show.ShowSeasonsFragment;
import com.williamcomartin.plexpyremote.SharedFragments.HistoryFragment;

public class UserPagerAdapter extends FragmentStatePagerAdapter {

    private final String[] tabNames = {"Profile", "Stats", "History"};

    private final FragmentManager fm;
    private String userID;

    public UserPagerAdapter(FragmentManager fm, String userID) {
        super(fm);

        this.fm = fm;
        this.userID = userID;
    }

    @Override
    public Fragment getItem(int index) {
        switch (index) {
            case 0:
                UserProfileFragment profileFrag = new UserProfileFragment();
                profileFrag.setUserID(userID);
                return profileFrag;
            case 1:
                UserStatsFragment statsFrag = new UserStatsFragment();
                statsFrag.setUserID(userID);
                return statsFrag;
            case 2:
                HistoryFragment historyFrag = new HistoryFragment();
                historyFrag.setUserID(userID);
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
