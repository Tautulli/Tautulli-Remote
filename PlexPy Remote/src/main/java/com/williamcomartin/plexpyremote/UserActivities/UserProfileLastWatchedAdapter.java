package com.williamcomartin.plexpyremote.UserActivities;

import android.content.Context;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.text.format.DateUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.williamcomartin.plexpyremote.Helpers.CircularNetworkImageView;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.ImageCacheManager;
import com.williamcomartin.plexpyremote.Models.HistoryModels;
import com.williamcomartin.plexpyremote.R;

import java.util.List;

/**
 * Created by wcomartin on 2017-07-15.
 */

public class UserProfileLastWatchedAdapter extends ArrayAdapter<HistoryModels.HistoryRecord> {
    private final Context context;
    private final List<HistoryModels.HistoryRecord> historyRecordList;

    public UserProfileLastWatchedAdapter(Context context, List<HistoryModels.HistoryRecord> historyRecordList) {
        super(context, -1, historyRecordList);
        this.context = context;
        this.historyRecordList = historyRecordList;
    }

    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        final HistoryModels.HistoryRecord historyItem = historyRecordList.get(position);

        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = inflater.inflate(R.layout.item_user_last_watched, parent, false);

//        view.findViewById(R.id.user_profile_last_watched_poster);
        NetworkImageView avatar = view.findViewById(R.id.user_profile_last_watched_poster);
        avatar.setImageUrl(UrlHelpers.getImageUrl(historyItem.thumb, "600", "400"),
                ImageCacheManager.getInstance().getImageLoader());

        if(historyItem.date != null && !historyItem.date.equals("null")){
            CharSequence timeAgo = DateUtils.getRelativeTimeSpanString(historyItem.date * 1000, System.currentTimeMillis(), 0);
            ((TextView) view.findViewById(R.id.user_profile_last_watched_date)).setText(timeAgo.toString());
        }

        ((TextView) view.findViewById(R.id.user_profile_last_watched_title)).setText(historyItem.fullTitle);
//        ((TextView) view.findViewById(R.id.user_profile_last_watched_transcode_decision)).setText(WordUtils.capitalize(historyItem.transcodeDecision));

        return view;
    }
}
