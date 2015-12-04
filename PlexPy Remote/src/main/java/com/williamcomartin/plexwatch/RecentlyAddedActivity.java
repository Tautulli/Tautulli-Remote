package com.williamcomartin.plexwatch;

import android.app.Activity;
import android.os.Bundle;
import android.support.v7.app.ActionBar;

public class RecentlyAddedActivity extends NavBaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_recently_added);
        setupActionBar();
    }

    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.recently_added);
    }
}
