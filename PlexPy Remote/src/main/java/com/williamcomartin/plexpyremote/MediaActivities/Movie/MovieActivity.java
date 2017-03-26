package com.williamcomartin.plexpyremote.MediaActivities.Movie;

import android.os.Bundle;
import android.support.design.widget.TabLayout;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBar;

import com.williamcomartin.plexpyremote.NavBaseActivity;
import com.williamcomartin.plexpyremote.R;

/**
 * Created by wcomartin on 2016-12-22.
 */

public class MovieActivity extends NavBaseActivity {

    private Bundle extras;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_media);
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
            actionBar.setTitle(extras.getString("Title"));
        }
    }

    protected void setupPager() {
        ViewPager viewPager = (ViewPager) findViewById(R.id.media_pager);
        MoviePagerAdapter pagerAdapter = new MoviePagerAdapter(getSupportFragmentManager(), extras.getString("RatingKey"));
        viewPager.setAdapter(pagerAdapter);

        TabLayout tabLayout = (TabLayout) findViewById(R.id.media_taber);
        tabLayout.setupWithViewPager(viewPager);
    }
}
