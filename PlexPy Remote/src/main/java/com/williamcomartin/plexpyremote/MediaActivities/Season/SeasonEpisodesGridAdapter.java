package com.williamcomartin.plexpyremote.MediaActivities.Season;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.ImageCacheManager;
import com.williamcomartin.plexpyremote.Models.LibraryMediaModels;
import com.williamcomartin.plexpyremote.R;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * Created by wcomartin on 2016-12-15.
 */

public class SeasonEpisodesGridAdapter extends BaseAdapter {
    private Context context;
    private List<LibraryMediaModels.LibraryMediaItem> episodes;

    public static class ViewHolder extends RecyclerView.ViewHolder {

        protected RelativeLayout vLayout;
        protected NetworkImageView vImage;
        protected TextView vTitle;
        protected TextView vNumber;

        public ViewHolder(final View itemView) {
            super(itemView);
            vLayout = (RelativeLayout) itemView.findViewById(R.id.show_episodes_card_layout);
            vImage = (NetworkImageView) itemView.findViewById(R.id.show_episodes_image);
            vTitle = (TextView) itemView.findViewById(R.id.show_episodes_title);
            vNumber = (TextView) itemView.findViewById(R.id.show_episodes_number);
        }
    }

    public SeasonEpisodesGridAdapter(Context context, List<LibraryMediaModels.LibraryMediaItem> episodes) {
        this.context = context;
        setEpisodes(episodes);
    }

    public void setEpisodes(final List<LibraryMediaModels.LibraryMediaItem> episodes) {
        Collections.sort(episodes, new Comparator<LibraryMediaModels.LibraryMediaItem>() {
            public int compare(LibraryMediaModels.LibraryMediaItem v1, LibraryMediaModels.LibraryMediaItem v2) {
                int v1MediaIndex = Integer.parseInt(v1.mediaIndex);
                int v2MediaIndex = Integer.parseInt(v2.mediaIndex);
                return v1MediaIndex - v2MediaIndex;
            }
        });
        this.episodes = episodes;
        notifyDataSetChanged();
    }

    public View getView(int position, View convertView, ViewGroup parent) {
        final LibraryMediaModels.LibraryMediaItem episode = episodes.get(position);
        final LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View view = convertView;
        final SeasonEpisodesGridAdapter.ViewHolder viewHolder;

        if(view == null){
            view = inflater.inflate(R.layout.item_episode, null);
            viewHolder = new SeasonEpisodesGridAdapter.ViewHolder(view);
            view.setTag(viewHolder);
        } else {
            viewHolder = (SeasonEpisodesGridAdapter.ViewHolder) view.getTag();
        }

        viewHolder.vImage.setImageUrl(UrlHelpers.getImageUrl(episode.thumb, "666", "1000"),
                ImageCacheManager.getInstance().getImageLoader());

        viewHolder.vTitle.setText(episode.title);
        viewHolder.vNumber.setText("Episode " + episode.mediaIndex);

        return view;
    }

    @Override
    public int getCount() {
        return episodes.size();
    }

    @Override
    public LibraryMediaModels.LibraryMediaItem getItem(int position) {
        return episodes.get(position);
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }
}