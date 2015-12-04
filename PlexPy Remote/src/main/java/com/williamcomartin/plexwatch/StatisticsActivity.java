package com.williamcomartin.plexwatch;

import android.app.Activity;
import android.os.Bundle;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBar;

import com.williamcomartin.plexwatch.Adapters.StatisticsPagerAdapter;

public class StatisticsActivity extends NavBaseActivity {

    ViewPager mViewPager;
    StatisticsPagerAdapter mStatisticsPagerAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_statistics);

        setupActionBar();
        setupPager();
        setupTabs();


    }

    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.statistics);
    }

    protected void setupPager() {
        mStatisticsPagerAdapter  = new StatisticsPagerAdapter(getSupportFragmentManager());
        mViewPager = (ViewPager) findViewById(R.id.statisticsPager);
        mViewPager.setAdapter(mStatisticsPagerAdapter);
        mViewPager.setOnPageChangeListener(
                new ViewPager.SimpleOnPageChangeListener() {
                    @Override
                    public void onPageSelected(int position) {
                        // When swiping between pages, select the
                        // corresponding tab.
                        getSupportActionBar().setSelectedNavigationItem(position);
                    }
                });
    }

    protected void setupTabs() {
        // Create a tab listener that is called when the user changes tabs.
        final ActionBar actionBar = getSupportActionBar();

        ActionBar.TabListener tabListener = new ActionBar.TabListener() {
            @Override
            public void onTabSelected(ActionBar.Tab tab, FragmentTransaction ft) {
                mViewPager.setCurrentItem(tab.getPosition());
            }

            @Override
            public void onTabUnselected(ActionBar.Tab tab, FragmentTransaction ft) {

            }

            @Override
            public void onTabReselected(ActionBar.Tab tab, FragmentTransaction ft) {

            }
        };

        String[] tabNames = getResources().getStringArray(R.array.StatisticsTabs);

        for(int i = 0; i < tabNames.length; i++){
            actionBar.addTab(
                    actionBar.newTab()
                            .setText(tabNames[i])
                            .setTabListener(tabListener));
        }

        actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);

    }
}
