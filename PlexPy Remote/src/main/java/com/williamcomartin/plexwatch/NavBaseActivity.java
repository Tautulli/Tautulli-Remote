package com.williamcomartin.plexwatch;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.LayoutRes;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

/**
 * Created by wcomartin on 2015-11-04.
 */
public class NavBaseActivity extends AppBaseActivity {

    private ActionBarDrawerToggle mDrawerToggle;
    private DrawerLayout mDrawerLayout;
    private NavigationView navigationView;
    private TextView drawerText1;
    private TextView drawerText2;

    @Override
    public void setContentView(@LayoutRes int layoutResID)
    {
        super.setContentView(layoutResID);
        onCreateDrawer();
    }

    @Override
    protected void onStart() {
        super.onStart();

        drawerText1.setText("PlexPy");
        drawerText2.setText("PennyTwo");
    }

    protected void onCreateDrawer() {

        moveDrawerToTop();

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeButtonEnabled(true);

        mDrawerLayout = (DrawerLayout)findViewById(R.id.drawer_layout);
        navigationView = (NavigationView) findViewById(R.id.navigation);

        // setup nav drawer items
        navigationView.inflateMenu(R.menu.drawer);
        final View headerView = navigationView.inflateHeaderView(R.layout.drawer_header);

        drawerText1 = (TextView) headerView.findViewById(R.id.drawerText1);
        drawerText2 = (TextView) headerView.findViewById(R.id.drawerText2);

        navigationView.setNavigationItemSelectedListener(
                new NavigationView.OnNavigationItemSelectedListener() {
                    @Override
                    public boolean onNavigationItemSelected(MenuItem menuItem) {
                        menuItem.setChecked(true);
                        onNavItemClick(menuItem.getItemId());
                        return true;
                    }
                });

        setupDrawer();






    }

    private void moveDrawerToTop() {
        // Inflate the "decor.xml"
        LayoutInflater inflater = (LayoutInflater) getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        DrawerLayout drawer = (DrawerLayout) inflater.inflate(R.layout.decor, null); // "null" is important.

        // HACK: "steal" the first child of decor view
        ViewGroup decor = (ViewGroup) getWindow().getDecorView();
        View child = decor.getChildAt(0);
        decor.removeView(child);
        FrameLayout container = (FrameLayout) drawer.findViewById(R.id.container); // This is the container we defined just now.
        container.addView(child);

        // Make the drawer replace the first child
        decor.addView(drawer);
    }

    private void onNavItemClick(int itemId) {
        Intent launchIntent = null;

        switch(itemId){
            case R.id.navigation_item_activity:
                launchIntent = new Intent(this, ActivityActivity.class);
                break;
            case R.id.navigation_item_users:
                launchIntent = new Intent(this, UsersActivity.class);
                break;
            case R.id.navigation_item_recently_added:
                launchIntent = new Intent(this, RecentlyAddedActivity.class);
                break;
            case R.id.navigation_item_history:
                launchIntent = new Intent(this, HistoryActivity.class);
                break;
            case R.id.navigation_item_graphs:
                launchIntent = new Intent(this, GraphsActivity.class);
                break;
            case R.id.navigation_item_statistics:
                launchIntent = new Intent(this, StatisticsActivity.class);
                break;

            case R.id.navigation_sub_item_settings:
                launchIntent = new Intent(this, SettingsActivity.class);
                break;
            case R.id.navigation_sub_item_about:
                launchIntent = new Intent(this, AboutActivity.class);
                break;
        }

        if (launchIntent != null) {
            startActivity(launchIntent);
            overridePendingTransition(R.anim.activity_fade_enter, R.anim.activity_fade_exit);
        }
        mDrawerLayout.closeDrawer(GravityCompat.START);
    }

    private void setupDrawer() {

        mDrawerToggle = new ActionBarDrawerToggle(this, mDrawerLayout,
                R.string.drawer_open, R.string.drawer_close) {

            /** Called when a drawer has settled in a completely open state. */
            public void onDrawerOpened(View drawerView) {
                super.onDrawerOpened(drawerView);
                invalidateOptionsMenu(); // creates call to onPrepareOptionsMenu()
            }
            /** Called when a drawer has settled in a completely closed state. */
            public void onDrawerClosed(View view) {
                super.onDrawerClosed(view);
                invalidateOptionsMenu(); // creates call to onPrepareOptionsMenu()
            }
        };

        mDrawerToggle.setDrawerIndicatorEnabled(true);
        mDrawerLayout.setDrawerListener(mDrawerToggle);

    }

    @Override
    protected void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        // Sync the toggle state after onRestoreInstanceState has occurred.
        mDrawerToggle.syncState();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
//        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
//        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
//        if (id == R.id.action_settings) {
//            return true;
//        }

        // Activate the navigation drawer toggle
        if (mDrawerToggle.onOptionsItemSelected(item)) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

}
