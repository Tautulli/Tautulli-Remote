package com.williamcomartin.plexwatch;

import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.williamcomartin.plexwatch.Helpers.DividerItemDecoration;
import com.williamcomartin.plexwatch.HomeComponents.StatsAdapter;
import com.williamcomartin.plexwatch.Models.Stat;

import java.util.ArrayList;
import java.util.List;

public class HomeActivity extends NavBaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        RecyclerView rvStats = (RecyclerView) findViewById(R.id.rvStats);

        StatsAdapter adapter = new StatsAdapter(fakeStats());

        rvStats.setAdapter(adapter);

        rvStats.setLayoutManager(new LinearLayoutManager(this));

        RecyclerView.ItemDecoration itemDecoration = new
                DividerItemDecoration(this, DividerItemDecoration.VERTICAL_LIST);
        rvStats.addItemDecoration(itemDecoration);
    }

    private List<Stat> fakeStats() {
        List<Stat> list = new ArrayList<>();

        list.add(new Stat("Users", 4));
        list.add(new Stat("Disney", 328));
        list.add(new Stat("Home Videos", 1));
        list.add(new Stat("Movies", 1526));
        list.add(new Stat("TV Shows", 90));
        list.add(new Stat("TV Episodes", 6911));
        list.add(new Stat("Total Plays", 95));

        return list;

    }

}
