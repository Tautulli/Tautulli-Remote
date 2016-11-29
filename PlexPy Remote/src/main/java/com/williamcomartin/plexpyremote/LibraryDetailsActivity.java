package com.williamcomartin.plexpyremote;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.williamcomartin.plexpyremote.Adapters.LibraryDetailsPagerAdapter;
import com.williamcomartin.plexpyremote.Adapters.StatisticsPagerAdapter;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Models.LibraryStatisticsModels;

/**
 * Created by wcomartin on 2016-11-27.
 */

public class LibraryDetailsActivity extends NavBaseActivity {


    ViewPager mViewPager;
    LibraryDetailsPagerAdapter mLibraryDetailsPagerAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_library_details);

        setupActionBar();
        setupPager();
        setupTabs();

        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            ActionBar actionBar = getSupportActionBar();
            actionBar.setTitle(extras.getString("LibraryTitle"));
        }

    }

    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.libraries);
    }

    protected void setupPager() {
        mLibraryDetailsPagerAdapter  = new LibraryDetailsPagerAdapter(getSupportFragmentManager());
        mViewPager = (ViewPager) findViewById(R.id.library_details_pager);
        mViewPager.setAdapter(mLibraryDetailsPagerAdapter);
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

        String[] tabNames = {"Profile", "History", "Media Info"};

        for(int i = 0; i < tabNames.length; i++){
            actionBar.addTab(
                    actionBar.newTab()
                            .setText(tabNames[i])
                            .setTabListener(tabListener));
        }

        actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);

    }
}
