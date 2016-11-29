package com.williamcomartin.plexpyremote.Adapters;

import android.widget.BaseAdapter;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.android.volley.toolbox.NetworkImageView;
import com.williamcomartin.plexpyremote.R;

/**
 * Created by wcomartin on 2016-11-27.
 */

public class UserTopStatAdapter extends BaseAdapter {
    private Context context;
    private final String[] users;

    public UserTopStatAdapter(Context context, String[] users) {
        this.context = context;
        this.users = users;
    }

    public View getView(int position, View convertView, ViewGroup parent) {

        LayoutInflater inflater = (LayoutInflater) context
                .getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        View gridView;

        if (convertView == null) {

            gridView = new View(context);

            // get layout from mobile.xml
            gridView = inflater.inflate(R.layout.item_user_top_stat, null);

            // set value into textview
            TextView textView = (TextView) gridView
                    .findViewById(R.id.user_top_stat_name);
            textView.setText(users[position]);

            // set image based on selected text
            NetworkImageView imageView = (NetworkImageView) gridView
                    .findViewById(R.id.user_top_stat_image);

        } else {
            gridView = (View) convertView;
        }

        return gridView;
    }

    @Override
    public int getCount() {
        return users.length;
    }

    @Override
    public Object getItem(int position) {
        return null;
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }
}
