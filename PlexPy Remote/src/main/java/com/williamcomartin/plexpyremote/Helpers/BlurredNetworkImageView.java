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
                getBlurBitmap(bm)));
    }

    public Bitmap getBlurBitmap(Bitmap bitmap){

        //Let's create an empty bitmap with the same size of the bitmap we want to blur
        Bitmap outBitmap = Bitmap.createBitmap(bitmap.getWidth(), bitmap.getHeight(), Bitmap.Config.ARGB_8888);

        //Instantiate a new Renderscript
        RenderScript rs = RenderScript.create(mContext);

        //Create an Intrinsic Blur Script using the Renderscript
        ScriptIntrinsicBlur blurScript = ScriptIntrinsicBlur.create(rs, Element.U8_4(rs));

        //Create the Allocations (in/out) with the Renderscript and the in/out bitmaps
        Allocation allIn = Allocation.createFromBitmap(rs, bitmap);
        Allocation allOut = Allocation.createFromBitmap(rs, outBitmap);

        //Set the radius of the blur
        blurScript.setRadius(25.f);

        //Perform the Renderscript
        blurScript.setInput(allIn);
        blurScript.forEach(allOut);

        //Copy the final bitmap created by the out Allocation to the outBitmap
        allOut.copyTo(outBitmap);


        /**
         * The original post asks to recycle the bitmap, to better handle memory management.
         * This is not possible in this current situation, since volley uses a cached version of
         * this image. If you do recycle, the mBuffer property of the bitmap will be null and the
         * Allocation.createFromBitmap method will fail due to this.
         * Practically, this means, that the second time the user tries to access the blurred image
         * the system will crash
         **/
        //recycle the original bitmap
        //bitmap.recycle();

        //After finishing everything, we destroy the Renderscript.
        rs.destroy();

        return outBitmap;


    }
}
