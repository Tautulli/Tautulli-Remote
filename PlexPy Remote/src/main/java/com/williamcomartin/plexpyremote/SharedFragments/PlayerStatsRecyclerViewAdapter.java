package com.williamcomartin.plexpyremote.SharedFragments;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.williamcomartin.plexpyremote.Helpers.ImageHelper;
import com.williamcomartin.plexpyremote.Models.UserPlayerStatsModels;
import com.williamcomartin.plexpyremote.R;
import com.williamcomartin.plexpyremote.Services.PlatformService;

import java.util.List;

public class PlayerStatsRecyclerViewAdapter extends RecyclerView.Adapter<PlayerStatsRecyclerViewAdapter.ViewHolder> {

    private final List<UserPlayerStatsModels.PlayerStat> mValues;
    private Context context;

    public PlayerStatsRecyclerViewAdapter(List<UserPlayerStatsModels.PlayerStat> items) {
        mValues = items;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.fragment_player_stats_item, parent, false);
        context = view.getContext();
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, int position) {
        holder.mItem = mValues.get(position);

        Bitmap platform = BitmapFactory.decodeResource(
                context.getResources(), PlatformService.getInstance().getPlatformImagePath(holder.mItem.platformType));
        holder.mAvatarView.setImageBitmap(ImageHelper.getRoundedCornerBitmap(platform, 30));
        holder.mNameView.setText(holder.mItem.playerName);
        holder.mPlaysView.setText(String.valueOf(holder.mItem.totalPlays));
    }

    @Override
    public int getItemCount() {
        return mValues.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        public final View mView;
        public final ImageView mAvatarView;
        public final TextView mNameView;
        public final TextView mPlaysView;
        public UserPlayerStatsModels.PlayerStat mItem;

        public ViewHolder(View view) {
            super(view);
            mView = view;
            mAvatarView = view.findViewById(R.id.player_stats_item_avatar);
            mNameView = view.findViewById(R.id.player_stats_item_name);
            mPlaysView = view.findViewById(R.id.player_stats_item_plays);
        }

        @Override
        public String toString() {
            return super.toString() + " '" + mNameView.getText() + "'";
        }
    }
}
