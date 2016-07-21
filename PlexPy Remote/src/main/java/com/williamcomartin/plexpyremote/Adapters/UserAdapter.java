package com.williamcomartin.plexpyremote.Adapters;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.support.v7.widget.RecyclerView;
import android.text.format.DateUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.williamcomartin.plexpyremote.ApplicationController;
import com.williamcomartin.plexpyremote.Models.UserModels;
import com.williamcomartin.plexpyremote.R;

import java.util.List;

/**
 * Created by wcomartin on 2015-11-20.
 */
public class UserAdapter extends RecyclerView.Adapter<UserAdapter.ViewHolder> {

    private final OnItemClickListener listener;

    public interface OnItemClickListener {
        void onItemClick(UserModels.User item);
    }

    private SharedPreferences SP;

    public static class ViewHolder extends RecyclerView.ViewHolder {

        protected TextView vUserName;
        protected TextView vLastSeen;
        protected TextView vTotalPlays;

        protected TextView vIPAddress;
        protected TextView vPlayer;
        protected TextView vPlatform;
        protected TextView vLastWatched;


        protected NetworkImageView vImage;

        public ViewHolder(View itemView) {
            super(itemView);

            vUserName = (TextView) itemView.findViewById(R.id.user_card_name);
            vLastSeen = (TextView) itemView.findViewById(R.id.user_card_last_seen);
            vTotalPlays = (TextView) itemView.findViewById(R.id.user_card_total_plays);

            vIPAddress = (TextView) itemView.findViewById(R.id.user_card_ip);
            vPlayer = (TextView) itemView.findViewById(R.id.user_card_player);
            vPlatform = (TextView) itemView.findViewById(R.id.user_card_platform);
            vLastWatched = (TextView) itemView.findViewById(R.id.user_card_watched);

            vImage = (NetworkImageView) itemView.findViewById(R.id.user_card_image);
        }
    }

    private List<UserModels.User> users;

    // Pass in the contact array into the constructor
    public UserAdapter(List<UserModels.User> users, OnItemClickListener listener) {
        this.users = users;
        this.listener = listener;
        SP = PreferenceManager.getDefaultSharedPreferences(ApplicationController.getInstance().getApplicationContext());
    }

    @Override
    public UserAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        Context context = parent.getContext();
        LayoutInflater inflater = LayoutInflater.from(context);

        // Inflate the custom layout
        View contactView = inflater.inflate(R.layout.item_user, parent, false);

        // Return a new holder instance
        ViewHolder viewHolder = new ViewHolder(contactView);
        return viewHolder;
    }

    @Override
    public void onBindViewHolder(UserAdapter.ViewHolder viewHolder, int position) {
        // Get the data model based on position
        final UserModels.User user = users.get(position);

        // Set item views based on the data model

        viewHolder.vUserName.setText(user.friendlyName);
        viewHolder.vTotalPlays.setText(user.plays.toString());

        if (user.ipAddress != null) {
            viewHolder.vIPAddress.setText(user.ipAddress);
        }

        viewHolder.vPlatform.setText(user.platform);
        viewHolder.vPlayer.setText(user.player);
        viewHolder.vLastWatched.setText(user.lastPlayed);

        viewHolder.vImage.setImageUrl(user.userThumb, ApplicationController.getInstance().getImageLoader());

        if(user.lastSeen != null && !user.lastSeen.equals("null")){
            CharSequence timeAgo = DateUtils.getRelativeTimeSpanString(user.lastSeen * 1000, System.currentTimeMillis(), 0);
            viewHolder.vLastSeen.setText(timeAgo.toString());
        }

        viewHolder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                listener.onItemClick(user);
            }
        });

    }

    @Override
    public int getItemCount() {
        return users.size();
    }
}
