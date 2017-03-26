package com.williamcomartin.plexpyremote;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.app.FragmentTransaction;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBar;
import android.view.View;

import com.williamcomartin.plexpyremote.Adapters.LibraryDetailsPagerAdapter;

/**
 * Created by wcomartin on 2016-11-27.
 */

public class LibraryDetailsActivity extends NavBaseActivity {

    Bundle extras;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_library_details);
        extras = getIntent().getExtras();

        setupActionBar();
        setupPager();

    }

    @Override
    protected void setupDrawer(){
        super.setupDrawer();
        pageHasDrawer = false;
        mDrawerToggle.setDrawerIndicatorEnabled(false);
    }

    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();

        if (extras != null) {
            actionBar.setTitle(extras.getString("LibraryTitle"));
        } else {
            actionBar.setTitle(R.string.libraries);
        }

    }

    protected void setupPager() {
        ViewPager viewPager = (ViewPager) findViewById(R.id.library_details_pager);
        LibraryDetailsPagerAdapter pagerAdapter = new LibraryDetailsPagerAdapter(getSupportFragmentManager(), extras.getString("LibraryId"));
        viewPager.setAdapter(pagerAdapter);

        TabLayout tabLayout = (TabLayout) findViewById(R.id.library_details_taber);
        tabLayout.setupWithViewPager(viewPager);
    }
}
