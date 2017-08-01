package com.williamcomartin.plexpyremote;

import android.app.FragmentTransaction;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.GravityCompat;
import android.support.v7.app.ActionBar;

import com.mikepenz.aboutlibraries.LibsBuilder;
import com.mikepenz.aboutlibraries.ui.LibsFragment;

public class AboutActivity extends NavBaseActivity {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_about);
        setupActionBar();

        LibsFragment fragment = new LibsBuilder()
                .withLicenseShown(true)
                .withAboutIconShown(true)
//                .withAboutAppName(getString(R.string.app_name))
                .withVersionShown(true)
                .withAboutVersionShown(true)
                .withAboutDescription("PlexPy Remote connects to your existing PlexPy server for easy mobile access. " +
                        "Just enter your server address and API key to connect and view current activity, server stats, and more.")
                .fragment();

        FragmentTransaction fragmentTransaction = getFragmentManager().beginTransaction();
        fragmentTransaction.add(R.id.about_frame_layout, fragment);
        fragmentTransaction.commit();
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
