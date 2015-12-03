package com.williamcomartin.plexwatch;

import android.app.Activity;
import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;

import com.williamcomartin.plexwatch.Adapters.StatsAdapter;
import com.williamcomartin.plexwatch.Adapters.UserAdapter;
import com.williamcomartin.plexwatch.Helpers.DividerItemDecoration;
import com.williamcomartin.plexwatch.Models.User;

import java.util.ArrayList;
import java.util.List;

public class UsersActivity extends NavBaseActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_users);
        setupActionBar();

        RecyclerView rvUsers = (RecyclerView) findViewById(R.id.rvUsers);

        UserAdapter adapter = new UserAdapter(fakeUsers());

        rvUsers.setAdapter(adapter);

        rvUsers.setLayoutManager(new LinearLayoutManager(this));
    }

    protected void setupActionBar() {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setTitle(R.string.users);
    }

    private List<User> fakeUsers(){
        List<User> list = new ArrayList<>();

        list.add(CreateFakeUser("wcomartin"));
        list.add(CreateFakeUser("drivard100"));
        list.add(CreateFakeUser("dcomartin"));
        list.add(CreateFakeUser("wcomartin"));
        list.add(CreateFakeUser("drivard100"));
        list.add(CreateFakeUser("dcomartin"));
        list.add(CreateFakeUser("wcomartin"));
        list.add(CreateFakeUser("drivard100"));
        list.add(CreateFakeUser("dcomartin"));
        list.add(CreateFakeUser("wcomartin"));
        list.add(CreateFakeUser("drivard100"));
        list.add(CreateFakeUser("dcomartin"));
        list.add(CreateFakeUser("wcomartin"));
        list.add(CreateFakeUser("drivard100"));
        list.add(CreateFakeUser("dcomartin"));
        list.add(CreateFakeUser("wcomartin"));
        list.add(CreateFakeUser("drivard100"));
        list.add(CreateFakeUser("dcomartin"));

        return list;
    }

    private User CreateFakeUser(String Name){
        User user = new User();
        user.user = Name;
        user.do_notify = "Checked";
        user.friendly_name = "Deslyn";
        user.id = 52;
        user.ip_address = null;
        user.keep_history = "Checked";
        user.last_seen = 1448072544;
        user.last_watched = "21 Jump Street - Blindsided";
        user.media_type = "episode";
        user.platform = "Chromecast";
        user.player = "Chromecast";
        user.plays = 5;
        user.rating_key = 4629;
        user.thumb = "/library/metadata/4620/thumb/1441552010";
        user.user_id = 5627461;
        user.user_thumb = "https://secure.gravatar.com/avatar/b680e17a09c5e967f045f021d9c7c16e?d=https%3A%2F%2Fplex.tv%2Favatars%2F75AE94%2F44%2F1";
        user.video_decision = "transcode";

        return user;
    }
}
