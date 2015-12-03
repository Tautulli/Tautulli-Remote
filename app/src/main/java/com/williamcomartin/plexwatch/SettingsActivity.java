package com.williamcomartin.plexwatch;

import android.app.Activity;
import android.os.Bundle;
import android.support.v7.app.ActionBar;

public class SettingsActivity extends NavBaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_settings);
        setupActionBar();
    }

    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.settings);
    }
}
