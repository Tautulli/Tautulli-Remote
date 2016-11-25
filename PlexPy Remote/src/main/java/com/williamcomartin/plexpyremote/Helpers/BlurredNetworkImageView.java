package com.williamcomartin.plexpyremote.Helpers;

import android.content.Context;

import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;

import android.renderscript.Allocation;
import android.renderscript.Element;
import android.renderscript.RenderScript;
import android.renderscript.ScriptIntrinsicBlur;

import android.util.AttributeSet;

import com.android.volley.toolbox.NetworkImageView;

/**
 * Created by wcomartin on 2016-11-17.
 */

public class BlurredNetworkImageView extends NetworkImageView {
    Context mContext;

    public BlurredNetworkImageView(Context context) {
        super(context);
        mContext = context;
    }

    public BlurredNetworkImageView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
        mContext = context;
    }

    public BlurredNetworkImageView(Context context, AttributeSet attrs,
                                   int defStyle) {
        super(context, attrs, defStyle);
        mContext = context;
    }


    @Override
    public void setImageBitmap(Bitmap bm) {
        if(bm==null) return;
        setImageDrawable(new BitmapDrawable(mContext.getResources(),
                ImageHelper.getBlurBitmap(bm)));
    }
}
