package com.williamcomartin.plexpyremote;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.GravityCompat;
import android.support.v7.app.ActionBar;

public class AboutActivity extends NavBaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_about);
        setupActionBar();
    }

    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.about);
    }

    @Override
    public void onBackPressed() {
        if (mainDrawerLayout.isDrawerOpen(GravityCompat.START)) {
            super.onBackPressed();
            return;
        }


        Intent intent = new Intent(this, ActivityActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
    }
}
