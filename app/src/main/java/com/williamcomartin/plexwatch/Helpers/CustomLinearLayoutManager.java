package com.williamcomartin.plexwatch.Helpers;

import android.content.Context;
import android.support.v7.widget.LinearLayoutManager;

/**
 * Created by wcomartin on 2015-11-04.
 */
public class CustomLinearLayoutManager extends LinearLayoutManager {
    public CustomLinearLayoutManager(Context context, int orientation, boolean reverseLayout) {
        super(context, orientation, reverseLayout);

    }

    // it will always pass false to RecyclerView when calling "canScrollVertically()" method.
    @Override
    public boolean canScrollVertically() {
        return false;
    }
}