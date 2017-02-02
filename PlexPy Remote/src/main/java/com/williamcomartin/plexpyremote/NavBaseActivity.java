package com.williamcomartin.plexpyremote;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.annotation.LayoutRes;
import android.support.design.widget.NavigationView;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.text.SpannableString;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.TextView;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.joanzapata.iconify.Icon;
import com.joanzapata.iconify.IconDrawable;
import com.joanzapata.iconify.fonts.FontAwesomeIcons;
import com.joanzapata.iconify.fonts.MaterialIcons;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;
import com.williamcomartin.plexpyremote.Models.ServerFriendlyNameModels;
import com.williamcomartin.plexpyremote.Services.NavService;

import java.net.MalformedURLException;

/**
 * Created by wcomartin on 2015-11-04.
 */
public class NavBaseActivity extends AppBaseActivity {

    private ActionBarDrawerToggle mDrawerToggle;
    protected DrawerLayout mainDrawerLayout;
    protected NavigationView navigationView;
    private TextView drawerText1;
    private TextView drawerText2;

    private SharedPreferences SP;


    private static MenuItem activeMenuItem;

    @Override
    public void setContentView(@LayoutRes int layoutResID) {
        super.setContentView(layoutResID);
        onCreateDrawer();

        setIcons();
    }

    @Override
    protected void onResume() {
        super.onResume();
        setIcons();
    }

    protected void setIcons() {

        Menu menu = navigationView.getMenu();

        setupNavItem(R.id.navigation_item_activity, MaterialIcons.md_tv);
        setupNavItem(R.id.navigation_item_users, MaterialIcons.md_people);
        setupNavItem(R.id.navigation_item_recently_added, MaterialIcons.md_movie);
        setupNavItem(R.id.navigation_item_history, MaterialIcons.md_restore);
        setupNavItem(R.id.navigation_item_statistics, MaterialIcons.md_insert_chart);
        setupNavItem(R.id.navigation_item_libraries, FontAwesomeIcons.fa_th_list);
        setupNavItem(R.id.navigation_sub_item_settings, MaterialIcons.md_settings);
        setupNavItem(R.id.navigation_sub_item_about, MaterialIcons.md_info);
        setupNavItem(R.id.navigation_sub_item_donate, FontAwesomeIcons.fa_paypal);

        if (NavService.getInstance().currentNav == 0) {
            NavService.getInstance().currentNav = R.id.navigation_item_activity;
        }
        setActive(NavService.getInstance().currentNav);
    }

    private void setupNavItem(int item, Icon icon) {
        MenuItem navItem = navigationView.getMenu().findItem(item);

        int color = ContextCompat.getColor(this, R.color.colorTextPrimary);

        SpannableString s = new SpannableString(navItem.getTitle());
        s.setSpan(new ForegroundColorSpan(color), 0, s.length(), 0);
        navItem.setTitle(s);

        navItem.setIcon(new IconDrawable(this, icon).color(color));
    }

    private void setActive(int item) {
        NavService.getInstance().currentNav = item;

        NavBaseActivity.activeMenuItem = navigationView.getMenu().findItem(item);
        int color = ContextCompat.getColor(this, R.color.colorAccent);

        SpannableString s = new SpannableString(NavBaseActivity.activeMenuItem.getTitle());
        s.setSpan(new ForegroundColorSpan(color), 0, s.length(), 0);
        NavBaseActivity.activeMenuItem.setTitle(s);

        IconDrawable activeIcon = (IconDrawable) NavBaseActivity.activeMenuItem.getIcon();
        activeIcon.color(color);
    }

    @Override
    protected void onStart() {
        super.onStart();

        SP = PreferenceManager.getDefaultSharedPreferences(getApplicationContext());

        try {
            String url = UrlHelpers.getHostPlusAPIKey() + "&cmd=get_server_friendly_name";
            GsonRequest<ServerFriendlyNameModels> request = new GsonRequest<>(
                    url,
                    ServerFriendlyNameModels.class,
                    null,
                    requestListener(),
                    errorListener()
            );

            RequestManager.addToRequestQueue(request);
        } catch (NoServerException | MalformedURLException e) {
            e.printStackTrace();
        }

        drawerText1.setText(SP.getString("server_settings_address", ""));
    }

    private Response.ErrorListener errorListener() {
        return new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
            }
        };
    }

    private Response.Listener<ServerFriendlyNameModels> requestListener() {
        return new Response.Listener<ServerFriendlyNameModels>() {
            @Override
            public void onResponse(ServerFriendlyNameModels response) {
                drawerText2.setText(response.response.data);
            }
        };
    }

    protected void onCreateDrawer() {

        moveDrawerToTop();

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeButtonEnabled(true);

        mainDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
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

        switch (itemId) {
            case R.id.navigation_item_activity:
                setActive(R.id.navigation_item_activity);
                launchIntent = new Intent(this, ActivityActivity.class);
                launchIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
                break;
            case R.id.navigation_item_users:
                setActive(R.id.navigation_item_users);
                launchIntent = new Intent(this, UsersActivity.class);
                break;
            case R.id.navigation_item_recently_added:
                setActive(R.id.navigation_item_recently_added);
                launchIntent = new Intent(this, RecentlyAddedActivity.class);
                break;
            case R.id.navigation_item_history:
                setActive(R.id.navigation_item_history);
                launchIntent = new Intent(this, HistoryActivity.class);
                break;
            /*case R.id.navigation_item_graphs:
                setActive(R.id.navigation_item_graphs);
                launchIntent = new Intent(this, GraphsActivity.class);
                break;*/
            case R.id.navigation_item_statistics:
                setActive(R.id.navigation_item_statistics);
                launchIntent = new Intent(this, StatisticsActivity.class);
                break;
            case R.id.navigation_item_libraries:
                setActive(R.id.navigation_item_libraries);
                launchIntent = new Intent(this, LibraryStatisticsActivity.class);
                break;

            case R.id.navigation_sub_item_settings:
                setActive(R.id.navigation_sub_item_settings);
                launchIntent = new Intent(this, SettingsActivity.class);
                break;
            case R.id.navigation_sub_item_about:
                setActive(R.id.navigation_sub_item_about);
                launchIntent = new Intent(this, AboutActivity.class);
                break;
            case R.id.navigation_sub_item_donate:
                launchIntent = new Intent(Intent.ACTION_VIEW);
                launchIntent.setData(Uri.parse("https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=ADRXXSWUJF788"));
                break;
        }

        if (launchIntent != null) {
            startActivity(launchIntent);
            overridePendingTransition(R.anim.activity_fade_enter, R.anim.activity_fade_exit);
        }
        mainDrawerLayout.closeDrawer(GravityCompat.START);
    }

    private void setupDrawer() {

        mDrawerToggle = new ActionBarDrawerToggle(this, mainDrawerLayout,
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
        mainDrawerLayout.setDrawerListener(mDrawerToggle);

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
        // as you specify a parent activityMenuItem in AndroidManifest.xml.
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

    @Override
    public void onBackPressed() {
        if (mainDrawerLayout.isDrawerOpen(GravityCompat.START)) {
            mainDrawerLayout.closeDrawer(GravityCompat.START);
            return;
        }
        super.onBackPressed();
    }
}
