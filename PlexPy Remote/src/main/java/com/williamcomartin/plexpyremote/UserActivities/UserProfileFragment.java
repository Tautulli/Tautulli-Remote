package com.williamcomartin.plexpyremote.UserActivities;

import android.content.Context;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;
import android.text.format.DateUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.android.volley.Response;
import com.williamcomartin.plexpyremote.Adapters.HistoryAdapter;
import com.williamcomartin.plexpyremote.Helpers.CircularNetworkImageView;
import com.williamcomartin.plexpyremote.Helpers.Exceptions.NoServerException;
import com.williamcomartin.plexpyremote.Helpers.UrlHelpers;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.GsonRequest;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.ImageCacheManager;
import com.williamcomartin.plexpyremote.Helpers.VolleyHelpers.RequestManager;
import com.williamcomartin.plexpyremote.Models.ActivityModels;
import com.williamcomartin.plexpyremote.Models.HistoryModels;
import com.williamcomartin.plexpyremote.Models.UserModels;
import com.williamcomartin.plexpyremote.R;

import java.net.MalformedURLException;
import java.util.ArrayList;

public class UserProfileFragment extends Fragment {

    private ViewGroup container;

    public UserProfileFragment() {
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        this.container = container;
        return inflater.inflate(R.layout.fragment_user_profile, container, false);
    }

    public void setUserID(String userID) {
        try {
            Uri.Builder builder = UrlHelpers.getUriBuilder();
            builder.appendQueryParameter("cmd", "get_users_table");
            builder.appendQueryParameter("user_id", userID);

            GsonRequest<UserModels> request = new GsonRequest<>(
                    builder.toString(),
                    UserModels.class,
                    null,
                    requestListener(),
                    errorListener()
            );

            RequestManager.addToRequestQueue(request);
        } catch (NoServerException | MalformedURLException e) {

        }

        try {
            Uri.Builder builder = UrlHelpers.getUriBuilder();
            builder.appendQueryParameter("cmd", "get_history");
            builder.appendQueryParameter("user_id", userID);
            builder.appendQueryParameter("length", "5");

            GsonRequest<HistoryModels> request = new GsonRequest<>(
                    builder.toString(),
                    HistoryModels.class,
                    null,
                    requestHistoryListener(),
                    errorListener()
            );

            RequestManager.addToRequestQueue(request);
        } catch (NoServerException | MalformedURLException e) {

        }
    }

    private Response.ErrorListener errorListener() {
        return null;
    }

    private Response.Listener<UserModels> requestListener() {
        return new Response.Listener<UserModels>() {
            @Override
            public void onResponse(UserModels response) {
                UserModels.User user = response.response.data.data.get(0);

                Uri.Builder builder = Uri.parse(user.userThumb).buildUpon();
                builder.appendQueryParameter("s", "100");

                CircularNetworkImageView avatar = container.findViewById(R.id.user_profile_avatar);
                avatar.setImageUrl(builder.toString(),
                        ImageCacheManager.getInstance().getImageLoader());

                ((TextView) container.findViewById(R.id.user_profile_ip_address)).setText(user.ipAddress);

                if(user.lastSeen != null && !user.lastSeen.equals("null")){
//                    Log.d("UserProfileFragment", "LastSeen" +  String.valueOf(Long.valueOf(user.lastSeen) * 1000));
//                    Log.d("UserProfileFragment", "  System" + String.valueOf(System.currentTimeMillis()));
                    CharSequence timeAgo = DateUtils.getRelativeTimeSpanString(user.lastSeen * 1000, System.currentTimeMillis(), 0);
                    ((TextView) container.findViewById(R.id.user_profile_last_seen)).setText(timeAgo.toString());
                } else {
                    ((TextView) container.findViewById(R.id.user_profile_last_seen)).setText("Never");
                }

//                ListView lastWatchedList = container.findViewById(R.id.user_profile_last_watched_list);
//                lastWatchedList.setAdapter(new UserProfileLastWatchedAdapter(getContext()));
            }
        };
    }

    private Response.Listener<HistoryModels> requestHistoryListener() {
        return new Response.Listener<HistoryModels>() {
            @Override
            public void onResponse(HistoryModels response) {
                ((ListView) container.findViewById(R.id.user_profile_last_watched_list))
                        .setAdapter(new UserProfileLastWatchedAdapter(getContext(), response.response.data.data));
            }
        };
    }
}
